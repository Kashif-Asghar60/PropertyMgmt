import 'package:flutter/material.dart';

class AppConstants {
  // App-wide constants
  static const String appName = "PropertyMgmt_UAE";
  static const String logoImagePath = "assets/logo.png";
  static const Color whitecontainer = Colors.white;
  static const Color whiteTxtColor = Colors.white;
  static const Color BlackTxtColor = Colors.black;
  static const Color content_areaClr = Color(0xFFf2f3fc);
  static const Color purplethemecolor = Color(0xff2b3576);

  static const Color greenbutton = Color(0xFF14C368);
}

class FirebaseConstants {
    static const String users = "Users";

  static const String masterParty = "MasterParty";
    static const String rentalProperties = "RentalProperties";
  static const String rentalUnits = "RentalUnits";
  static const String tenants = "Tenants";
    static const String unitIssued = "UnitsIssued";

  static const String contracts = "Contracts";
    static const String payments = "Payments";
}

class Dimensions {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double contentscreenHeightpercentage = 60;

  static double paddingPercentage = 4.0; // 4%
  static double fontSizePercentage = 4.5; // 4.5%
  static double iconSizePercentage = 1.5; // 1.5%
  static double textSizePercentage = 1.4; // 1.4%
  static double containerPaddingPercentage = 1.0; // 1%
  static double containerMarginPercentage = 1.0; // 1%
  static double logoSizePercentage = 18.0; // 15%
  static double userProfileHeightPercentage = 9.0; // 9%

  static double sizeboxWidthPercentage = 0.4; // 0.4%
  static double imglogoSizePercentage = 2.0; // 15%

  //textfield
  static double spaceBetweenTxtFieldpercentage = 2.0;
  static double rowspaceBetweenTxtFieldpercentage = 7.0;

  static double widthTxtFieldpercentage = 20.0;
  static double textfontpercentage = 1.2;
  static double widthSearchTxtFieldpercentage = .15;
//tenants
  static double tenantspaddingpercentage = 3.2;
// Button
  static double ButtonWidthpercentage = 7.1;
  static double ButtonHeightpercentage = 3.1;
//Tablw
  static double dataTableWidthpercentage = 82;
  static double dataCellWidthpercentage = 20;
  // Calculate dimensions based on screen size
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    //cheque
paddingcheque  =
        screenHeight * (sizeboxWidthPercentage) / 100.0;

    contentscreenHeight =
        screenHeight * (contentscreenHeightpercentage) / 100.0;
    //Datatablw:
    dataTableWidth = screenWidth * (dataTableWidthpercentage) / 100.0;
    dataCellWidth = screenWidth * (dataCellWidthpercentage) / 100.0;
    //button
    buttonHeight = screenWidth * (ButtonHeightpercentage) / 100.0;
    buttonWidth = screenWidth * (ButtonWidthpercentage) / 100.0;
//tenants
    paddingtenants = screenWidth * (tenantspaddingpercentage) / 100.0;
// textfield
    widthSearchTxtField = screenWidth * (widthSearchTxtFieldpercentage) / 100.0;
    spaceBetweenTxtField =
        screenWidth * (spaceBetweenTxtFieldpercentage) / 100.0;
    widthTxtField = screenWidth * (widthTxtFieldpercentage) / 100.0;
    Txtfontsize = screenWidth * (textfontpercentage) / 100.0;
    rowspaceBetweenTxtField =
        screenWidth * (rowspaceBetweenTxtFieldpercentage) / 100.0;
//
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
  }

  static double contentscreenHeight = 0.0;
  // Dimension constants
  static double padding = 0.0;
  static double fontSize = 0.0;
  static double iconSize = 0.0;
  static double textSize = 0.0;
  static double containerPadding = 0.0;
  static double containerMargin = 0.0;
  static double logoSize = 0.0;
  static double imglogoSize = 0.0;
  static double userProfileHeight = 0.0;
  static double sizeboxWidth = 0.0;
// Datatable
  static double dataTableWidth = 0.0;
  static double dataCellWidth = 0.0;

  /// Textfield
  static double widthSearchTxtField = 0.0;
  static double spaceBetweenTxtField = 0.0;
  static double widthTxtField = 0.0;
  static double Txtfontsize = 0.0;
  static double rowspaceBetweenTxtField = 0.0;

  //tenents
  static double paddingtenants = 0.0;

  //Buttons
  static double buttonWidth = 0.0;
  static double buttonHeight = 0.0;


  //chquespadding
    static double paddingcheque = 0.0;
}
