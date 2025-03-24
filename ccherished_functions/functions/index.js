/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const {Timestamp} = require("firebase-admin/firestore");

// Initialize Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();

exports.fetchAnalytics = onRequest(async (request, response) => {
  const userId = request.query.userId;

  if (!userId) {
    // If userId is not provided, return a 400 error
    response.status(400).json({error: "Missing userId parameter"});
    return;
  }

  try {
    const friendHistorySnapshot = await db
        .collection("contact_history")
        .where("userId", "==", userId)
        .get();

    if (friendHistorySnapshot.empty) {
      // If no documents are found, return an empty list
      response.status(200).json({contactHistory: []});
      return;
    }
    const groupedData = {};
    friendHistorySnapshot.docs.forEach((doc) => {
      const data = doc.data();
      const friendId = data.friendId;
      const lastContacted = data.lastContacted.toDate().toISOString().split("T")[0];
      if (friendId) {
        if (!groupedData[friendId]) {
          groupedData[friendId] = [];
        }
        if (lastContacted) {
          groupedData[friendId].push(lastContacted);
        }
      }
    });
    // Process grouped data to calculate weekly, monthly, and yearly counts
    const result = {};
    Object.entries(groupedData).forEach(([friendId, contactedDates]) => {
      const weeklyCounts = getWeeklyCounts(contactedDates);
      const monthlyCounts = getMonthlyCounts(contactedDates);
      const yearlyCounts = getYearlyCounts(contactedDates);

      result[friendId] = {
        week: weeklyCounts,
        month: monthlyCounts,
        year: yearlyCounts,
      };
    });

    // Calculate aggregated counts for all friends
    const aggregatedCounts = getAllCounts(result);
    result["all"] = aggregatedCounts;
    // const friends = friendHistorySnapshot.docs.map((doc) => ({
    //   friendId: doc.id,
    //   data: doc.data().contactHistory || [],
    // }));

    // Log the result for debugging purposes
    logger.info(`Fetched analytics for userId: ${userId}`, {result});

    // Return the list of friends
    response.status(200).json({analytics: result});
  } catch (error) {
    // Handle any errors
    logger.error("Error fetching analytics:", error);
    response.status(500).json({error: "Internal Server Error"});
  }
});

exports.updateContactHistory = onRequest(async (req, res) => {
  const {friendId, contactDate} = req.body;
  if (!friendId || !contactDate) {
    res.status(400).json({error: "Missing friendId or contactDate"});
    return;
  }
  try {
    const providedDate = Timestamp.fromDate(new Date(contactDate));
    // Query for documents where friendId == friendId
    const historySnapshot = await db
        .collection("contact_history")
        .where("friendId", "==", friendId)
        .get();
    if (historySnapshot.empty) {
      res.status(200).json({message: "No matching records found."});
      return;
    }
    // Batch delete any docs whose lastContacted > providedDate
    const batch = db.batch();
    historySnapshot.forEach((doc) => {
      const recordDate = doc.data().lastContacted; // Firestore Timestamp
      if (recordDate && recordDate.toMillis() >= providedDate.toMillis()) {
        batch.delete(doc.ref);
      }
    });
    await batch.commit();
    res.status(200).json({message: "Contact history updated successfully!"});
  } catch (error) {
    console.error("Error updating contact history:", error);
    res.status(500).json({error: "Internal Server Error"});
  }
});

function getWeeklyCounts(dates) {
  const now = new Date();
  const startOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 1)); // Start of the week (Monday)
  const endOfWeek = new Date(startOfWeek);
  endOfWeek.setDate(startOfWeek.getDate() + 6); // End of the week (Sunday)

  const weeklyCounts = {
    Mon: 0,
    Tue: 0,
    Wed: 0,
    Thu: 0,
    Fri: 0,
    Sat: 0,
    Sun: 0,
  };

  dates.forEach((date) => {
    const dateObj = new Date(date);
    if (dateObj >= startOfWeek && dateObj <= endOfWeek) {
      const day = dateObj.toLocaleDateString("en-US", {weekday: "short"});
      weeklyCounts[day]++;
    }
  });

  return weeklyCounts;
}

function getMonthlyCounts(dates) {
  const now = new Date();
  const currentYear = now.getFullYear();

  const monthlyCounts = {
    Jan: 0,
    Feb: 0,
    Mar: 0,
    Apr: 0,
    May: 0,
    Jun: 0,
    Jul: 0,
    Aug: 0,
    Sep: 0,
    Oct: 0,
    Nov: 0,
    Dec: 0,
  };

  dates.forEach((date) => {
    const dateObj = new Date(date);
    if (dateObj.getFullYear() === currentYear) {
      const month = dateObj.toLocaleDateString("en-US", {month: "short"});
      monthlyCounts[month]++;
    }
  });

  return monthlyCounts;
}

function getYearlyCounts(dates) {
  const now = new Date();
  const currentYear = now.getFullYear();
  const startYear = currentYear - 5; // Last 5 years

  const yearlyCounts = {};
  for (let year = startYear; year <= currentYear; year++) {
    yearlyCounts[year] = 0;
  }

  dates.forEach((date) => {
    const dateObj = new Date(date);
    const year = dateObj.getFullYear();
    if (yearlyCounts[year] !== undefined) {
      yearlyCounts[year]++;
    }
  });

  return yearlyCounts;
}


function getAllCounts(result) {
  const allWeeklyCounts = {};
  const allMonthlyCounts = {};
  const allYearlyCounts = {};

  Object.values(result).forEach((friendData) => {
    const {week, month, year} = friendData;

    // Aggregate weekly counts
    Object.entries(week).forEach(([day, count]) => {
      allWeeklyCounts[day] = (allWeeklyCounts[day] || 0) + count;
    });

    // Aggregate monthly counts
    Object.entries(month).forEach(([month, count]) => {
      allMonthlyCounts[month] = (allMonthlyCounts[month] || 0) + count;
    });

    // Aggregate yearly counts
    Object.entries(year).forEach(([year, count]) => {
      allYearlyCounts[year] = (allYearlyCounts[year] || 0) + count;
    });
  });

  return {
    week: allWeeklyCounts,
    month: allMonthlyCounts,
    year: allYearlyCounts,
  };
}
