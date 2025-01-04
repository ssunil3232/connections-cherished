import 'package:connectionscherished/styles/button_styles.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DropdownItems {
  String value;
  String label;
  bool enabledButton;
  Widget ? customItem;
  double ? customHeight;
  DropdownItems({
    this.value = '',
    required this.label, 
    required this.enabledButton, 
    this.customItem,
    this.customHeight
  });
}

// ignore: must_be_immutable
class CustomDropdownWidget extends StatefulWidget {
  String? labelText;
  String? placeholderText;
  double? menuHeight;
  double? menuWidth;
  double? buttonWidth;
  double? buttonHeight;
  EdgeInsetsGeometry ? buttonPadding;
  Color ? defaultBorderColor;
  Color ? activeBorderColor;
  Color ? errorBorderColor;
  Color ? disabledBorderColor;
  Color ? buttonBgColor;
  /// This is the initial selected **value** in the dropdown.
  /// Not the label.
  String? initialValue;
  bool errorState;
  String errorText;
  bool disabled;
  /// If we want a custom error message.
  /// Such as with icons etc.
  /// Other than a one-line text.
  Widget ? customErrorMessage;
  Offset ? offset;
  Function (String) onChanged;
  List<DropdownItems> dropdownItems;
  TextStyle ? selectionTextStyle;
  Color ? dropdownColor;
  final BoxBorder defaultButtonBorder;
  final BoxBorder activeButtonBorder;
  final BoxBorder errorButtonBorder;
  final BoxBorder disabledButtonBorder;
  bool ? isOptional;
  BoxBorder currentButtonBorder;

  CustomDropdownWidget({
    super.key,
    this.menuHeight,
    this.menuWidth,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonPadding,
    this.offset,
    this.disabled = false,
    this.defaultBorderColor,
    this.activeBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.buttonBgColor,
    this.initialValue,
    required this.onChanged,
    this.labelText,
    this.placeholderText,
    required this.dropdownItems,
    this.errorState = false,
    this.isOptional = false,
    this.errorText = 'Invalid input',
    this.customErrorMessage,
    this.dropdownColor,
    this.selectionTextStyle
  }) :
    currentButtonBorder = Border.all(
      color: defaultBorderColor ?? GlobalStyles.cardBorderDefault,
      width: 1.0,
    ),
    defaultButtonBorder = Border.all(
      color: defaultBorderColor ?? GlobalStyles.cardBorderDefault,
      width: 1.0,
    ),
    activeButtonBorder = Border.all(
      color: activeBorderColor ?? GlobalStyles.globalTextSubtle,
      width: 2.0,
    ),
    errorButtonBorder = Border.all(
      color: errorBorderColor ?? GlobalStyles.globalErrorBorder,
      width: 2.0,
    ),
    disabledButtonBorder = Border.all(
      color: disabledBorderColor ?? GlobalStyles.globalBorderDisabled,
      width: 1.0,
    );

  @override
  _CustomDropdownWidgetState createState() => _CustomDropdownWidgetState();
}
class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {  

  var selectedValue;

  @override
  void initState() {
    super.initState();
    if(widget.initialValue != '' || widget.initialValue == null){
      selectedValue = widget.initialValue;
    }
    else {
      selectedValue = null;
    }
    getDropdownItems();
  }

  @override
  void didUpdateWidget(CustomDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        if(widget.initialValue != '' || widget.initialValue == null){
          selectedValue = widget.initialValue;
        }
      });
    }
  }

  handleSelection(String value){
    if(value != '') {
      setState(() {
        selectedValue = value;
      });
    }
    widget.onChanged(value);
  }

  bool isOpen = false;
  menuOpened(bool isOpened) {
    setState(() {
      isOpen = isOpened;
      widget.currentButtonBorder = widget.errorState 
        ? widget.errorButtonBorder 
        : (isOpened ? widget.activeButtonBorder : widget.defaultButtonBorder);
    });
  }

  setInitialLoadValue() {
    if (widget.dropdownItems.any((item) => item.value == selectedValue)) {
      return selectedValue;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.labelText!= null)
          Row(children: [
            Text(widget.labelText!, style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle)),
            if(widget.isOptional==true) 
              Padding(
                padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing4),
                child: Text("(optional)", style: GlobalStyles.textStyles.caption2.copyWith(color: GlobalStyles.globalTextSubtle)),
              )
          ],),
        if(widget.labelText!= null)
          SizedBox(height: GlobalStyles.spacingStates.spacing4,),
          DropdownButtonHideUnderline(
            child: 
              DropdownButton2<dynamic>(
                onMenuStateChange: menuOpened,
                selectedItemBuilder: (context) {
                  return widget.dropdownItems.map<Widget>((DropdownItems item) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.label,
                        style: (widget.selectionTextStyle ?? GlobalStyles.textStyles.body1).copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList();
                },
                style: (widget.selectionTextStyle ?? GlobalStyles.textStyles.body1).copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
                hint: Text(
                  widget.placeholderText ?? 'Select a value',
                  style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.inputPlaceholderText),
                ),
                isExpanded: true,
                items: getDropdownItems(),
                value: setInitialLoadValue(),
                onChanged: widget.disabled ? null : (value) => handleSelection(value as String),
                buttonStyleData: ButtonStyleData(
                  padding: widget.buttonPadding ?? EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16, vertical: 18),
                  height: widget.buttonHeight ?? 60,
                  width: widget.buttonWidth ?? double.infinity,
                  decoration: BoxDecoration(
                    border: widget.errorState ? widget.errorButtonBorder : isOpen ? widget.activeButtonBorder : widget.defaultButtonBorder,
                    color:  widget.errorState ? GlobalStyles.globalErrorBg : widget.buttonBgColor ??  GlobalStyles.globalBgDefault,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbVisibility: WidgetStateProperty.all<bool>(false),
                    trackVisibility: WidgetStateProperty.all<bool>(false),
                  ),
                  padding: const EdgeInsets.all(0),
                  elevation: 0,
                  offset: widget.offset ?? Offset(0, -GlobalStyles.spacingStates.spacing8),
                  width: widget.menuWidth,
                  maxHeight: widget.menuHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GlobalStyles.globalTextSubtle,
                      width: 1.0, 
                      strokeAlign: BorderSide.strokeAlignOutside
                    ),
                    color: GlobalStyles.globalBgDefault,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  isOverButton: false,
                ),
                menuItemStyleData: MenuItemStyleData(
                  customHeights: getCustomHeight(),
                  padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16, vertical: GlobalStyles.spacingStates.spacing12),
                  selectedMenuItemBuilder: (ctx, item) {
                    return Container(
                      color: GlobalStyles.cardBgSelected,
                      child: item
                    );
                  },
                  overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                ),
                iconStyleData: IconStyleData(
                  openMenuIcon: VariedIcon.varied(Symbols.keyboard_arrow_up_rounded, color: widget.errorState ? GlobalStyles.globalIconError : widget.dropdownColor ?? GlobalStyles.globalIconDefault),
                  icon: VariedIcon.varied(Symbols.keyboard_arrow_down_rounded, color: widget.errorState ? GlobalStyles.globalIconError : widget.dropdownColor ?? GlobalStyles.globalIconDefault)
                ),
              ),
            ),
          if(widget.errorState)
            Container(
              padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing4),
              child: widget.customErrorMessage ??
              Text(
                widget.errorText, 
                softWrap: true,
                maxLines: null,
                overflow: TextOverflow.visible,
                style: GlobalStyles.textStyles.caption1.copyWith(color: GlobalStyles.globalErrorText)),
            ),
        
      ],
    );
  }

  List<double> getCustomHeight() {
    List<double> customHeights = [];
    for (var item in widget.dropdownItems) {
      customHeights.add(item.customHeight ?? kMinInteractiveDimension);
    }
    return customHeights; 
  }

  List<DropdownMenuItem> getDropdownItems(){
    List<DropdownMenuItem> items = [];
    items = widget.dropdownItems.map((
      (item) => DropdownMenuItem(
        enabled: item.enabledButton,
        value: item.value,
        child: item.customItem ?? StatefulBuilder(
          builder: (context, menuSetState) {
            bool isSelected = selectedValue == item.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected ? GlobalStyles.textStyles.boldBody1.copyWith(color: ButtonStyles.secondaryBtnStyle.text) : GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle)
                  )
                ),
              if (isSelected) 
                VariedIcon.varied(Symbols.check_rounded, color: ButtonStyles.secondaryBtnStyle.text)
              ] 
            );
          }
       )
      )
    )).toList();

    return items;
  }
}