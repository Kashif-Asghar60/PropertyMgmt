import 'package:flutter/material.dart';

class DimensionsProvider with ChangeNotifier {
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  double contentscreenHeightpercentage = 60;

  double paddingPercentage = 4.0; // 4%
  double fontSizePercentage = 4.5; // 4.5%
  double iconSizePercentage = 1.5; // 1.5%
  double textSizePercentage = 1.4; // 1.4%
  double containerPaddingPercentage = 1.0; // 1%
  double containerMarginPercentage = 1.0; // 1%
  double logoSizePercentage = 18.0; // 15%
  double userProfileHeightPercentage = 9.0; // 9%

  double sizeboxWidthPercentage = 0.4; // 0.4%
  double imglogoSizePercentage = 2.0; // 15%

  //textfield
  double spaceBetweenTxtFieldpercentage = 2.0;
  double rowspaceBetweenTxtFieldpercentage = 7.0;

  double widthTxtFieldpercentage = 20.0;
  double textfontpercentage = 1.2;
  double widthSearchTxtFieldpercentage = .15;

  //tenants
  double tenantspaddingpercentage = 3.2;

  // Button
  double ButtonWidthpercentage = 7.1;
  double ButtonHeightpercentage = 3.1;

  // Tablw
  double dataTableWidthpercentage = 82;
  double dataCellWidthpercentage = 20;

  // Dimension constants
  double contentscreenHeight = 0.0;
  double padding = 0.0;
  double fontSize = 0.0;
  double iconSize = 0.0;
  double textSize = 0.0;
  double containerPadding = 0.0;
  double containerMargin = 0.0;
  double logoSize = 0.0;
  double imglogoSize = 0.0;
  double userProfileHeight = 0.0;
  double sizeboxWidth = 0.0;

  // Datatable
  double dataTableWidth = 0.0;
  double dataCellWidth = 0.0;

  // Textfield
  double widthSearchTxtField = 0.0;
  double spaceBetweenTxtField = 0.0;
  double widthTxtField = 0.0;
  double Txtfontsize = 0.0;
  double rowspaceBetweenTxtField = 0.0;

  // Tenants
  double paddingtenants = 0.0;

  // Buttons
  double buttonWidth = 0.0;
  double buttonHeight = 0.0;

  // Cheques padding
  double paddingcheque = 0.0;

  // Method to initialize dimensions
  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    contentscreenHeight =
        screenHeight * (contentscreenHeightpercentage) / 100.0;

    dataTableWidth = screenWidth * (dataTableWidthpercentage) / 100.0;
    dataCellWidth = screenWidth * (dataCellWidthpercentage) / 100.0;

    buttonHeight = screenWidth * (ButtonHeightpercentage) / 100.0;
    buttonWidth = screenWidth * (ButtonWidthpercentage) / 100.0;

    paddingtenants = screenWidth * (tenantspaddingpercentage) / 100.0;

    widthSearchTxtField =
        screenWidth * (widthSearchTxtFieldpercentage) / 100.0;
    spaceBetweenTxtField =
        screenWidth * (spaceBetweenTxtFieldpercentage) / 100.0;
    widthTxtField = screenWidth * (widthTxtFieldpercentage) / 100.0;
    Txtfontsize = screenWidth * (textfontpercentage) / 100.0;
    rowspaceBetweenTxtField =
        screenWidth * (rowspaceBetweenTxtFieldpercentage) / 100.0;

    padding = (screenWidth * paddingPercentage) / 100.0;
    fontSize = (screenWidth * fontSizePercentage) / 100.0;
    iconSize = (screenWidth * iconSizePercentage) / 100.0;
    textSize = (screenWidth * textSizePercentage) / 100.0;
    containerPadding = (screenWidth * containerPaddingPercentage) / 100.0;
    containerMargin = (screenWidth * containerMarginPercentage) / 100.0;
    logoSize = (screenWidth * logoSizePercentage) / 100.0;
    imglogoSize = (screenWidth * imglogoSizePercentage) / 100.0;
    userProfileHeight = (screenHeight * userProfileHeightPercentage) / 100.0;
    sizeboxWidth = (screenWidth * sizeboxWidthPercentage) / 100.0;
    paddingcheque =
        screenHeight * (sizeboxWidthPercentage) / 100.0;
    notifyListeners(); // Notify listeners when dimensions change
  }
}
