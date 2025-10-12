import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Baby Log'**
  String get appTitle;

  /// No description provided for @homeEditBabyTooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar bebé'**
  String get homeEditBabyTooltip;

  /// No description provided for @homeEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Aquí aparecerán las métricas y registros de tu bebé.'**
  String get homeEmptyDescription;

  /// Mensaje de error cuando la pantalla inicial no puede cargar los datos del bebé
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la información del bebé.\n{error}'**
  String homeLoadError(Object error);

  /// No description provided for @formEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar bebé'**
  String get formEditTitle;

  /// No description provided for @formCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar bebé'**
  String get formCreateTitle;

  /// No description provided for @formGenderBoy.
  ///
  /// In es, this message translates to:
  /// **'Niño'**
  String get formGenderBoy;

  /// No description provided for @formGenderGirl.
  ///
  /// In es, this message translates to:
  /// **'Niña'**
  String get formGenderGirl;

  /// No description provided for @formGenderBoySemantic.
  ///
  /// In es, this message translates to:
  /// **'Bebé niño'**
  String get formGenderBoySemantic;

  /// No description provided for @formGenderGirlSemantic.
  ///
  /// In es, this message translates to:
  /// **'Bebé niña'**
  String get formGenderGirlSemantic;

  /// No description provided for @formNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del bebé'**
  String get formNameLabel;

  /// No description provided for @formNameHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre'**
  String get formNameHint;

  /// No description provided for @formNameError.
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio'**
  String get formNameError;

  /// No description provided for @formBirthSection.
  ///
  /// In es, this message translates to:
  /// **'Nacimiento'**
  String get formBirthSection;

  /// No description provided for @formBirthDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get formBirthDateLabel;

  /// No description provided for @formBirthDatePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha'**
  String get formBirthDatePlaceholder;

  /// No description provided for @formBirthTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get formBirthTimeLabel;

  /// No description provided for @formBirthTimePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la hora'**
  String get formBirthTimePlaceholder;

  /// No description provided for @formBirthDateHelp.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get formBirthDateHelp;

  /// No description provided for @formBirthTimeHelp.
  ///
  /// In es, this message translates to:
  /// **'Hora de nacimiento'**
  String get formBirthTimeHelp;

  /// No description provided for @formMeasurementsSection.
  ///
  /// In es, this message translates to:
  /// **'Medidas al nacer'**
  String get formMeasurementsSection;

  /// No description provided for @formWeightLabel.
  ///
  /// In es, this message translates to:
  /// **'Peso (kg)'**
  String get formWeightLabel;

  /// No description provided for @formWeightHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. 3.20'**
  String get formWeightHint;

  /// No description provided for @formHeightLabel.
  ///
  /// In es, this message translates to:
  /// **'Altura (cm)'**
  String get formHeightLabel;

  /// No description provided for @formHeightHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. 50.5'**
  String get formHeightHint;

  /// No description provided for @formInterfaceColorTitle.
  ///
  /// In es, this message translates to:
  /// **'Color de la interfaz'**
  String get formInterfaceColorTitle;

  /// No description provided for @formInterfaceColorSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Toca para elegir el color de acento.'**
  String get formInterfaceColorSubtitle;

  /// No description provided for @formColorPickerTitle.
  ///
  /// In es, this message translates to:
  /// **'Color de la interfaz'**
  String get formColorPickerTitle;

  /// No description provided for @formColorPickerConfirm.
  ///
  /// In es, this message translates to:
  /// **'De acuerdo'**
  String get formColorPickerConfirm;

  /// No description provided for @formSheetCloseTooltip.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get formSheetCloseTooltip;

  /// No description provided for @formSaveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get formSaveButton;

  /// No description provided for @formPhotoSheetCamera.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get formPhotoSheetCamera;

  /// No description provided for @formPhotoSheetGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de la galería'**
  String get formPhotoSheetGallery;

  /// Mensaje cuando la imagen seleccionada no se pudo guardar
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la imagen: {error}'**
  String formPhotoLoadError(Object error);

  /// No description provided for @formBirthMissingError.
  ///
  /// In es, this message translates to:
  /// **'Completa la fecha y hora de nacimiento.'**
  String get formBirthMissingError;

  /// No description provided for @formUpdateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado.'**
  String get formUpdateSuccess;

  /// No description provided for @formCreateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Perfil guardado.'**
  String get formCreateSuccess;

  /// Mensaje cuando ocurre un error al guardar el perfil
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String formSaveError(Object error);

  /// No description provided for @dashboardBottleLabel.
  ///
  /// In es, this message translates to:
  /// **'Biber?n'**
  String get dashboardBottleLabel;

  /// No description provided for @dashboardDiaperLabel.
  ///
  /// In es, this message translates to:
  /// **'Caca'**
  String get dashboardDiaperLabel;

  /// No description provided for @dashboardVomitLabel.
  ///
  /// In es, this message translates to:
  /// **'V?mito'**
  String get dashboardVomitLabel;

  /// No description provided for @dashboardBathLabel.
  ///
  /// In es, this message translates to:
  /// **'Ba?o'**
  String get dashboardBathLabel;

  /// No description provided for @dashboardTemperatureLabel.
  ///
  /// In es, this message translates to:
  /// **'Temperatura'**
  String get dashboardTemperatureLabel;

  /// No description provided for @dashboardFoodLabel.
  ///
  /// In es, this message translates to:
  /// **'Comida'**
  String get dashboardFoodLabel;

  /// No description provided for @dashboardMedicalAgendaLabel.
  ///
  /// In es, this message translates to:
  /// **'Agenda m?dica'**
  String get dashboardMedicalAgendaLabel;

  /// No description provided for @dashboardMinutesAgoZero.
  ///
  /// In es, this message translates to:
  /// **'0 mins'**
  String get dashboardMinutesAgoZero;

  /// No description provided for @dashboardEventsEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'No se encontr? informaci?n'**
  String get dashboardEventsEmptyTitle;

  /// No description provided for @dashboardNavHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get dashboardNavHome;

  /// No description provided for @dashboardNavStats.
  ///
  /// In es, this message translates to:
  /// **'Estad?sticas'**
  String get dashboardNavStats;

  /// No description provided for @dashboardNavTimeline.
  ///
  /// In es, this message translates to:
  /// **'L?nea temporal'**
  String get dashboardNavTimeline;

  /// No description provided for @dashboardNavDevelopment.
  ///
  /// In es, this message translates to:
  /// **'Desarrollo'**
  String get dashboardNavDevelopment;

  /// No description provided for @dashboardNavAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get dashboardNavAccount;

  /// No description provided for @dashboardSearchTooltip.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get dashboardSearchTooltip;

  /// No description provided for @dashboardNotificationsTooltip.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get dashboardNotificationsTooltip;

  /// No description provided for @dashboardTodayLabel.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get dashboardTodayLabel;

  /// No description provided for @dashboardChangeDayTooltip.
  ///
  /// In es, this message translates to:
  /// **'Cambiar día'**
  String get dashboardChangeDayTooltip;

  /// No description provided for @dashboardImportTooltip.
  ///
  /// In es, this message translates to:
  /// **'Importar datos'**
  String get dashboardImportTooltip;

  /// No description provided for @dashboardExportTooltip.
  ///
  /// In es, this message translates to:
  /// **'Exportar datos'**
  String get dashboardExportTooltip;

  /// No description provided for @dashboardPediatricQuestionsLabel.
  ///
  /// In es, this message translates to:
  /// **'Preguntas al pediatra'**
  String get dashboardPediatricQuestionsLabel;

  /// No description provided for @bottleLogTitle.
  ///
  /// In es, this message translates to:
  /// **'Toma de biberón'**
  String get bottleLogTitle;

  /// No description provided for @bottleLogDateTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Día y hora'**
  String get bottleLogDateTimeLabel;

  /// No description provided for @bottleLogAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get bottleLogAmountLabel;

  /// No description provided for @bottleLogAmountUnit.
  ///
  /// In es, this message translates to:
  /// **'ml'**
  String get bottleLogAmountUnit;

  /// No description provided for @bottleLogNotesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get bottleLogNotesLabel;

  /// No description provided for @bottleLogNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Añade detalles que quieras recordar'**
  String get bottleLogNotesHint;

  /// No description provided for @bottleLogAmountValidation.
  ///
  /// In es, this message translates to:
  /// **'Introduce una cantidad válida'**
  String get bottleLogAmountValidation;

  /// No description provided for @bottleLogDecreaseTooltip.
  ///
  /// In es, this message translates to:
  /// **'Restar 5 ml'**
  String get bottleLogDecreaseTooltip;

  /// No description provided for @bottleLogIncreaseTooltip.
  ///
  /// In es, this message translates to:
  /// **'Sumar 5 ml'**
  String get bottleLogIncreaseTooltip;

  /// No description provided for @homeLogListTitle.
  ///
  /// In es, this message translates to:
  /// **'Últimos registros'**
  String get homeLogListTitle;

  /// No description provided for @stoolLogTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambio de pañal'**
  String get stoolLogTitle;

  /// No description provided for @stoolLogDateTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Día y hora'**
  String get stoolLogDateTimeLabel;

  /// No description provided for @stoolLogConsistencyLabel.
  ///
  /// In es, this message translates to:
  /// **'Consistencia'**
  String get stoolLogConsistencyLabel;

  /// No description provided for @stoolLogConsistencyLiquidOption.
  ///
  /// In es, this message translates to:
  /// **'Líquida'**
  String get stoolLogConsistencyLiquidOption;

  /// No description provided for @stoolLogConsistencySoftOption.
  ///
  /// In es, this message translates to:
  /// **'Blanda'**
  String get stoolLogConsistencySoftOption;

  /// No description provided for @stoolLogConsistencyFirmOption.
  ///
  /// In es, this message translates to:
  /// **'Firme'**
  String get stoolLogConsistencyFirmOption;

  /// No description provided for @stoolLogConsistencyLiquidDescription.
  ///
  /// In es, this message translates to:
  /// **'Caca líquida'**
  String get stoolLogConsistencyLiquidDescription;

  /// No description provided for @stoolLogConsistencySoftDescription.
  ///
  /// In es, this message translates to:
  /// **'Caca blanda'**
  String get stoolLogConsistencySoftDescription;

  /// No description provided for @stoolLogConsistencyFirmDescription.
  ///
  /// In es, this message translates to:
  /// **'Caca firme'**
  String get stoolLogConsistencyFirmDescription;

  /// No description provided for @stoolLogNotesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get stoolLogNotesLabel;

  /// No description provided for @stoolLogNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Añade detalles que quieras recordar'**
  String get stoolLogNotesHint;

  /// No description provided for @stoolLogConsistencyValidation.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una consistencia'**
  String get stoolLogConsistencyValidation;

  /// No description provided for @bottleLogListTitle.
  ///
  /// In es, this message translates to:
  /// **'Últimas tomas'**
  String get bottleLogListTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
