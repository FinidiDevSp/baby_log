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

  /// No description provided for @homeLogActionsTooltip.
  ///
  /// In es, this message translates to:
  /// **'Acciones del registro'**
  String get homeLogActionsTooltip;

  /// No description provided for @homeLogEditAction.
  ///
  /// In es, this message translates to:
  /// **'Modificar registro'**
  String get homeLogEditAction;

  /// No description provided for @homeLogDeleteAction.
  ///
  /// In es, this message translates to:
  /// **'Eliminar registro'**
  String get homeLogDeleteAction;

  /// Mensaje mostrado al eliminar un registro del resumen.
  ///
  /// In es, this message translates to:
  /// **'Registro eliminado.'**
  String get homeLogDeleteSuccess;

  /// Error al eliminar un registro del resumen.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar el registro: {error}'**
  String homeLogDeleteError(Object error);

  /// Título del diálogo que confirma la eliminación de un registro del resumen.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar registro?'**
  String get homeLogDeleteConfirmTitle;

  /// Mensaje del diálogo previo a eliminar un registro del resumen.
  ///
  /// In es, this message translates to:
  /// **'¿Quieres eliminar este registro? Esta acción no se puede deshacer.'**
  String get homeLogDeleteConfirmMessage;

  /// Botón principal para confirmar la eliminación de un registro.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get homeLogDeleteConfirmAction;

  /// Botón secundario para cancelar la eliminación del registro.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get homeLogDeleteCancelAction;

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
  /// **'Biberón'**
  String get dashboardBottleLabel;

  /// No description provided for @dashboardDiaperLabel.
  ///
  /// In es, this message translates to:
  /// **'Caca'**
  String get dashboardDiaperLabel;

  /// No description provided for @dashboardVomitLabel.
  ///
  /// In es, this message translates to:
  /// **'Vómito'**
  String get dashboardVomitLabel;

  /// No description provided for @dashboardBathLabel.
  ///
  /// In es, this message translates to:
  /// **'Baño'**
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
  /// **'AGENDA'**
  String get dashboardMedicalAgendaLabel;

  /// No description provided for @agendaTitle.
  ///
  /// In es, this message translates to:
  /// **'Agenda médica'**
  String get agendaTitle;

  /// No description provided for @agendaNewAppointmentTooltip.
  ///
  /// In es, this message translates to:
  /// **'Agregar cita'**
  String get agendaNewAppointmentTooltip;

  /// No description provided for @agendaCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva cita'**
  String get agendaCreateTitle;

  /// No description provided for @agendaEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar cita'**
  String get agendaEditTitle;

  /// No description provided for @agendaFormTitleLabel.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get agendaFormTitleLabel;

  /// No description provided for @agendaFormTitleError.
  ///
  /// In es, this message translates to:
  /// **'Escribe un título corto'**
  String get agendaFormTitleError;

  /// No description provided for @agendaFormTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo de cita'**
  String get agendaFormTypeLabel;

  /// No description provided for @agendaFormDateTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha y hora'**
  String get agendaFormDateTimeLabel;

  /// No description provided for @agendaFormDateTimeError.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha y hora exactas'**
  String get agendaFormDateTimeError;

  /// No description provided for @agendaFormNotesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get agendaFormNotesLabel;

  /// No description provided for @agendaFormCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get agendaFormCancel;

  /// No description provided for @agendaFormSaveNew.
  ///
  /// In es, this message translates to:
  /// **'Guardar cita'**
  String get agendaFormSaveNew;

  /// No description provided for @agendaFormSaveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get agendaFormSaveChanges;

  /// No description provided for @agendaSectionToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get agendaSectionToday;

  /// No description provided for @agendaSectionUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próximas'**
  String get agendaSectionUpcoming;

  /// No description provided for @agendaSectionPast.
  ///
  /// In es, this message translates to:
  /// **'Pasadas'**
  String get agendaSectionPast;

  /// No description provided for @agendaPastIndicator.
  ///
  /// In es, this message translates to:
  /// **'Completada'**
  String get agendaPastIndicator;

  /// No description provided for @agendaEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Aún no registraste citas médicas.'**
  String get agendaEmptyDescription;

  /// No description provided for @agendaEditAction.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get agendaEditAction;

  /// No description provided for @agendaDeleteAction.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get agendaDeleteAction;

  /// No description provided for @agendaDeleteConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cita'**
  String get agendaDeleteConfirmTitle;

  /// No description provided for @agendaDeleteConfirmMessage.
  ///
  /// In es, this message translates to:
  /// **'La cita se eliminará de la agenda.'**
  String get agendaDeleteConfirmMessage;

  /// No description provided for @agendaDeleteConfirmCancel.
  ///
  /// In es, this message translates to:
  /// **'Conservar'**
  String get agendaDeleteConfirmCancel;

  /// No description provided for @agendaDeleteConfirmAccept.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get agendaDeleteConfirmAccept;

  /// No description provided for @agendaCreateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Cita guardada.'**
  String get agendaCreateSuccess;

  /// No description provided for @agendaUpdateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Cita actualizada.'**
  String get agendaUpdateSuccess;

  /// No description provided for @agendaDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Cita eliminada.'**
  String get agendaDeleteSuccess;

  /// No description provided for @agendaTypeRevision.
  ///
  /// In es, this message translates to:
  /// **'Revisión'**
  String get agendaTypeRevision;

  /// No description provided for @agendaTypePediatrics.
  ///
  /// In es, this message translates to:
  /// **'Pediatría'**
  String get agendaTypePediatrics;

  /// No description provided for @agendaTypeVaccines.
  ///
  /// In es, this message translates to:
  /// **'Vacunas'**
  String get agendaTypeVaccines;

  /// No description provided for @agendaTypeEmergency.
  ///
  /// In es, this message translates to:
  /// **'Urgencias'**
  String get agendaTypeEmergency;

  /// No description provided for @dashboardAgendaStatusToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get dashboardAgendaStatusToday;

  /// No description provided for @dashboardAgendaStatusTomorrow.
  ///
  /// In es, this message translates to:
  /// **'Mañana'**
  String get dashboardAgendaStatusTomorrow;

  /// Indicador de días restantes para la próxima cita médica
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1 {En 1 día} other {En {count} días}}'**
  String dashboardAgendaStatusInDays(int count);

  /// No description provided for @dashboardAppointmentsChipLabelToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get dashboardAppointmentsChipLabelToday;

  /// No description provided for @dashboardAppointmentsChipLabelTomorrow.
  ///
  /// In es, this message translates to:
  /// **'Mañana'**
  String get dashboardAppointmentsChipLabelTomorrow;

  /// No description provided for @dashboardAppointmentsChipLabelInDays.
  ///
  /// In es, this message translates to:
  /// **'+{count} días'**
  String dashboardAppointmentsChipLabelInDays(int count);

  /// No description provided for @dashboardAppointmentsCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0 {Sin citas} =1 {1 cita} other {{count} citas}}'**
  String dashboardAppointmentsCount(int count);

  /// No description provided for @dashboardAppointmentsNoTime.
  ///
  /// In es, this message translates to:
  /// **'—'**
  String get dashboardAppointmentsNoTime;

  /// Estado mostrado en el acceso directo de preguntas cuando hay pendientes
  ///
  /// In es, this message translates to:
  /// **'{count, plural, one {{count} pendiente} other {{count} pendientes}}'**
  String dashboardQuestionsPending(int count);

  /// No description provided for @dashboardQuestionsAllClear.
  ///
  /// In es, this message translates to:
  /// **'Al día'**
  String get dashboardQuestionsAllClear;

  /// No description provided for @dashboardElapsedJustNow.
  ///
  /// In es, this message translates to:
  /// **'Justo ahora'**
  String get dashboardElapsedJustNow;

  /// Tiempo relativo en minutos desde el último evento
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1 {Hace 1 min} other {Hace {count} mins}}'**
  String dashboardElapsedMinutes(int count);

  /// Tiempo relativo en horas desde el último evento
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1 {Hace 1 h} other {Hace {count} h}}'**
  String dashboardElapsedHours(int count);

  /// Tiempo relativo en días desde el último evento
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1 {Hace 1 día} other {Hace {count} días}}'**
  String dashboardElapsedDays(int count);

  /// No description provided for @dashboardEventsEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'No se encontró información'**
  String get dashboardEventsEmptyTitle;

  /// No description provided for @dashboardNavHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get dashboardNavHome;

  /// No description provided for @dashboardNavStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get dashboardNavStats;

  /// No description provided for @dashboardNavTimeline.
  ///
  /// In es, this message translates to:
  /// **'Línea temporal'**
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

  /// Mensaje que resume el resultado de la importación desde CSV
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0 {No se importaron registros.} =1 {Se importó 1 registro correctamente.} other {Se importaron {count} registros correctamente.}}'**
  String dashboardImportSummary(int count);

  /// Error mostrado cuando falla la importación CSV
  ///
  /// In es, this message translates to:
  /// **'No se pudo importar el archivo: {reason}'**
  String dashboardImportError(String reason);

  /// No description provided for @dashboardImportReadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo leer el archivo seleccionado.'**
  String get dashboardImportReadError;

  /// No description provided for @dashboardImportDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Confirmar importacion'**
  String get dashboardImportDialogTitle;

  /// Resumen con la cantidad total detectada en el CSV
  ///
  /// In es, this message translates to:
  /// **'El archivo contiene {count, plural, =1 {1 registro.} other {{count} registros.}}'**
  String dashboardImportPreviewTotal(int count);

  /// Indica cuantos registros se crearan desde cero
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1 {Se creara 1 registro nuevo.} other {Se crearan {count} registros nuevos.}}'**
  String dashboardImportPreviewNew(int count);

  /// Indica cuantos registros coinciden con los existentes
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1 {1 registro coincide con los existentes.} other {{count} registros coinciden con los existentes.}}'**
  String dashboardImportPreviewDuplicates(int count);

  /// Advierte sobre filas que no se pudieron procesar
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1 {1 fila tiene errores y se omitira.} other {{count} filas tienen errores y se omitiran.}}'**
  String dashboardImportPreviewIssues(int count);

  /// No description provided for @dashboardImportNoData.
  ///
  /// In es, this message translates to:
  /// **'El archivo seleccionado no contiene registros.'**
  String get dashboardImportNoData;

  /// No description provided for @dashboardImportCancelAction.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get dashboardImportCancelAction;

  /// No description provided for @dashboardImportSkipAction.
  ///
  /// In es, this message translates to:
  /// **'Omitir duplicados'**
  String get dashboardImportSkipAction;

  /// No description provided for @dashboardImportOverwriteAction.
  ///
  /// In es, this message translates to:
  /// **'Sobrescribir duplicados'**
  String get dashboardImportOverwriteAction;

  /// No description provided for @dashboardImportConfirmAction.
  ///
  /// In es, this message translates to:
  /// **'Importar registros'**
  String get dashboardImportConfirmAction;

  /// No description provided for @dashboardExportTooltip.
  ///
  /// In es, this message translates to:
  /// **'Exportar datos'**
  String get dashboardExportTooltip;

  /// No description provided for @dashboardExportEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aun no hay datos para exportar.'**
  String get dashboardExportEmpty;

  /// Mensaje de error cuando falla la exportacion
  ///
  /// In es, this message translates to:
  /// **'No se pudo exportar la informacion: {reason}'**
  String dashboardExportError(String reason);

  /// Asunto utilizado al compartir el CSV exportado
  ///
  /// In es, this message translates to:
  /// **'Exportacion de Baby Log ({fileName})'**
  String dashboardExportShareSubject(String fileName);

  /// Texto incluido al compartir el CSV exportado
  ///
  /// In es, this message translates to:
  /// **'Este CSV incluye {count, plural, =1 {1 registro} other {{count} registros}} exportados desde Baby Log.'**
  String dashboardExportShareBody(int count);

  /// No description provided for @dashboardPediatricQuestionsLabel.
  ///
  /// In es, this message translates to:
  /// **'Preguntas'**
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

  /// No description provided for @bathLogTitle.
  ///
  /// In es, this message translates to:
  /// **'Baño'**
  String get bathLogTitle;

  /// No description provided for @bathLogTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo de baño'**
  String get bathLogTypeLabel;

  /// No description provided for @bathLogTypeFullOption.
  ///
  /// In es, this message translates to:
  /// **'Completo'**
  String get bathLogTypeFullOption;

  /// No description provided for @bathLogTypeQuickOption.
  ///
  /// In es, this message translates to:
  /// **'Rápido'**
  String get bathLogTypeQuickOption;

  /// No description provided for @bathLogTypeFullDescription.
  ///
  /// In es, this message translates to:
  /// **'Baño completo'**
  String get bathLogTypeFullDescription;

  /// No description provided for @bathLogTypeQuickDescription.
  ///
  /// In es, this message translates to:
  /// **'Baño rápido'**
  String get bathLogTypeQuickDescription;

  /// No description provided for @bathLogNotesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get bathLogNotesLabel;

  /// No description provided for @bathLogNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Añade detalles que quieras recordar'**
  String get bathLogNotesHint;

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

  /// No description provided for @vomitLogTitle.
  ///
  /// In es, this message translates to:
  /// **'Registro de vómito'**
  String get vomitLogTitle;

  /// No description provided for @vomitLogAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get vomitLogAmountLabel;

  /// No description provided for @vomitLogAmountLowOption.
  ///
  /// In es, this message translates to:
  /// **'Poca'**
  String get vomitLogAmountLowOption;

  /// No description provided for @vomitLogAmountMediumOption.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get vomitLogAmountMediumOption;

  /// No description provided for @vomitLogAmountHighOption.
  ///
  /// In es, this message translates to:
  /// **'Abundante'**
  String get vomitLogAmountHighOption;

  /// No description provided for @vomitLogAmountLowDescription.
  ///
  /// In es, this message translates to:
  /// **'Vómito ligero'**
  String get vomitLogAmountLowDescription;

  /// No description provided for @vomitLogAmountMediumDescription.
  ///
  /// In es, this message translates to:
  /// **'Vómito moderado'**
  String get vomitLogAmountMediumDescription;

  /// No description provided for @vomitLogAmountHighDescription.
  ///
  /// In es, this message translates to:
  /// **'Vómito abundante'**
  String get vomitLogAmountHighDescription;

  /// No description provided for @vomitLogNotesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get vomitLogNotesLabel;

  /// No description provided for @vomitLogNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Añade detalles que quieras recordar'**
  String get vomitLogNotesHint;

  /// No description provided for @vomitLogAmountValidation.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una cantidad'**
  String get vomitLogAmountValidation;

  /// No description provided for @temperatureLogTitle.
  ///
  /// In es, this message translates to:
  /// **'Temperatura'**
  String get temperatureLogTitle;

  /// No description provided for @temperatureLogValueLabel.
  ///
  /// In es, this message translates to:
  /// **'Temperatura'**
  String get temperatureLogValueLabel;

  /// No description provided for @temperatureLogValueUnit.
  ///
  /// In es, this message translates to:
  /// **'°C'**
  String get temperatureLogValueUnit;

  /// No description provided for @temperatureLogDecreaseTooltip.
  ///
  /// In es, this message translates to:
  /// **'Restar 0,1 °C'**
  String get temperatureLogDecreaseTooltip;

  /// No description provided for @temperatureLogIncreaseTooltip.
  ///
  /// In es, this message translates to:
  /// **'Sumar 0,1 °C'**
  String get temperatureLogIncreaseTooltip;

  /// No description provided for @temperatureLogValueValidation.
  ///
  /// In es, this message translates to:
  /// **'Introduce una temperatura válida'**
  String get temperatureLogValueValidation;

  /// No description provided for @temperatureLogNotesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get temperatureLogNotesLabel;

  /// No description provided for @temperatureLogNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Añade detalles que quieras recordar'**
  String get temperatureLogNotesHint;

  /// No description provided for @bottleLogListTitle.
  ///
  /// In es, this message translates to:
  /// **'Últimas tomas'**
  String get bottleLogListTitle;

  /// No description provided for @questionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Preguntas'**
  String get questionsTitle;

  /// No description provided for @questionsShareTooltip.
  ///
  /// In es, this message translates to:
  /// **'Compartir preguntas pendientes'**
  String get questionsShareTooltip;

  /// No description provided for @questionsShareTitle.
  ///
  /// In es, this message translates to:
  /// **'Preguntas para el pediatra'**
  String get questionsShareTitle;

  /// No description provided for @questionsShareMessage.
  ///
  /// In es, this message translates to:
  /// **'Estas son las dudas que queremos comentar en la próxima visita.'**
  String get questionsShareMessage;

  /// Error al generar o compartir el PDF
  ///
  /// In es, this message translates to:
  /// **'No se pudo compartir: {error}'**
  String questionsShareError(Object error);

  /// No description provided for @questionsValidationMessage.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu pregunta antes de guardar.'**
  String get questionsValidationMessage;

  /// Error al guardar una pregunta
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar la pregunta: {error}'**
  String questionsSaveError(Object error);

  /// Error al actualizar una pregunta
  ///
  /// In es, this message translates to:
  /// **'No se pudo actualizar la pregunta: {error}'**
  String questionsUpdateError(Object error);

  /// Error al eliminar una pregunta
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar la pregunta: {error}'**
  String questionsDeleteError(Object error);

  /// No description provided for @questionsComposerTitle.
  ///
  /// In es, this message translates to:
  /// **'Anota tu duda'**
  String get questionsComposerTitle;

  /// No description provided for @questionsComposerPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej. Recordar preguntar sobre la introducción de sólidos'**
  String get questionsComposerPlaceholder;

  /// No description provided for @questionsComposerAction.
  ///
  /// In es, this message translates to:
  /// **'Guardar pregunta'**
  String get questionsComposerAction;

  /// No description provided for @questionsComposerUpdateAction.
  ///
  /// In es, this message translates to:
  /// **'Actualizar pregunta'**
  String get questionsComposerUpdateAction;

  /// No description provided for @questionsComposerEditingNotice.
  ///
  /// In es, this message translates to:
  /// **'Editando una pregunta guardada'**
  String get questionsComposerEditingNotice;

  /// No description provided for @questionsComposerCancelEditing.
  ///
  /// In es, this message translates to:
  /// **'Cancelar edición'**
  String get questionsComposerCancelEditing;

  /// No description provided for @questionsPendingSection.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get questionsPendingSection;

  /// No description provided for @questionsResolvedSection.
  ///
  /// In es, this message translates to:
  /// **'Resueltas'**
  String get questionsResolvedSection;

  /// No description provided for @questionsDeleteDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar pregunta?'**
  String get questionsDeleteDialogTitle;

  /// No description provided for @questionsDeleteDialogMessage.
  ///
  /// In es, this message translates to:
  /// **'La pregunta se quitará de la lista.'**
  String get questionsDeleteDialogMessage;

  /// No description provided for @questionsDeleteDialogConfirm.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get questionsDeleteDialogConfirm;

  /// No description provided for @questionsEditDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar pregunta'**
  String get questionsEditDialogTitle;

  /// No description provided for @questionsEditDialogLabel.
  ///
  /// In es, this message translates to:
  /// **'Pregunta'**
  String get questionsEditDialogLabel;

  /// No description provided for @questionsEditDialogCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get questionsEditDialogCancel;

  /// No description provided for @questionsEditDialogSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get questionsEditDialogSave;

  /// No description provided for @questionsEditAction.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get questionsEditAction;

  /// No description provided for @questionsDeleteAction.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get questionsDeleteAction;

  /// No description provided for @questionsEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Anota tus dudas'**
  String get questionsEmptyTitle;

  /// No description provided for @questionsEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Guarda las preguntas que quieras llevar a la próxima visita con el pediatra.'**
  String get questionsEmptySubtitle;

  /// No description provided for @questionsLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar tus preguntas. Intenta de nuevo.'**
  String get questionsLoadError;

  /// No description provided for @questionsAgeUnknown.
  ///
  /// In es, this message translates to:
  /// **'Edad no disponible'**
  String get questionsAgeUnknown;

  /// No description provided for @questionsAgeLessThanWeek.
  ///
  /// In es, this message translates to:
  /// **'Menos de una semana'**
  String get questionsAgeLessThanWeek;

  /// Edad del bebé expresada en semanas
  ///
  /// In es, this message translates to:
  /// **'{count, plural, one {{count} semana} other {{count} semanas}}'**
  String questionsAgeWeeks(int count);

  /// Edad del bebé expresada en meses
  ///
  /// In es, this message translates to:
  /// **'{count, plural, one {{count} mes} other {{count} meses}}'**
  String questionsAgeMonths(int count);

  /// Edad combinando meses y semanas
  ///
  /// In es, this message translates to:
  /// **'{months, plural, one {{months} mes} other {{months} meses}} y {weeks, plural, one {{weeks} semana} other {{weeks} semanas}}'**
  String questionsAgeMonthsAndWeeks(int months, int weeks);

  /// Título del diálogo de satisfacción
  ///
  /// In es, this message translates to:
  /// **'¿Cómo salió la consulta?'**
  String get questionsSatisfactionTitle;

  /// Texto introductorio del diálogo de satisfacción
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos qué tan conforme quedaste con la respuesta.'**
  String get questionsSatisfactionSubtitle;

  /// Opción de satisfacción alta
  ///
  /// In es, this message translates to:
  /// **'Contentos'**
  String get questionsSatisfactionHappy;

  /// Opción de satisfacción neutra
  ///
  /// In es, this message translates to:
  /// **'Neutral'**
  String get questionsSatisfactionNeutral;

  /// Opción de satisfacción baja
  ///
  /// In es, this message translates to:
  /// **'Inconformes'**
  String get questionsSatisfactionSad;

  /// Etiqueta para el campo de comentarios tras resolver una duda
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales'**
  String get questionsSatisfactionNoteLabel;

  /// Botón para confirmar la selección de satisfacción
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get questionsSatisfactionConfirm;

  /// Botón para cerrar el diálogo sin guardar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get questionsSatisfactionCancel;

  /// Título general de la sección de cuenta
  ///
  /// In es, this message translates to:
  /// **'Mi cuenta'**
  String get accountSettingsTitle;

  /// Descripción breve para la sección de cuenta
  ///
  /// In es, this message translates to:
  /// **'Gestiona tus preferencias personales.'**
  String get accountSettingsSubtitle;

  /// Título del bloque para cambiar de idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma de la aplicación'**
  String get accountLanguageTitle;

  /// Descripción del bloque para cambiar de idioma
  ///
  /// In es, this message translates to:
  /// **'Elige el idioma que prefieres para BabyLog.'**
  String get accountLanguageSubtitle;

  /// Opción para idioma español
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get accountLanguageOptionSpanish;

  /// Opción para idioma inglés
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get accountLanguageOptionEnglish;

  /// Nota informativa sobre la persistencia del idioma
  ///
  /// In es, this message translates to:
  /// **'El cambio se aplica al instante y se recuerda para futuras sesiones.'**
  String get accountLanguageApplyHint;

  /// Etiqueta para la categoría de estadísticas de biberón
  ///
  /// In es, this message translates to:
  /// **'Biberón'**
  String get statsCategoryFeeding;

  /// Etiqueta para la categoría de estadísticas de pañales
  ///
  /// In es, this message translates to:
  /// **'Pañal'**
  String get statsCategoryDiapers;

  /// Etiqueta para la categoría de estadísticas de baño
  ///
  /// In es, this message translates to:
  /// **'Baño'**
  String get statsCategoryBath;

  /// Etiqueta para la categoría de estadísticas de vómito
  ///
  /// In es, this message translates to:
  /// **'Vómito'**
  String get statsCategoryVomit;

  /// Etiqueta que muestra el rango semanal
  ///
  /// In es, this message translates to:
  /// **'{range}'**
  String statsWeekLabel(Object range);

  /// Texto explicativo bajo el rango semanal
  ///
  /// In es, this message translates to:
  /// **'Datos de lunes a domingo'**
  String get statsWeekSubtitle;

  /// Tooltip del botón para ir a la semana anterior
  ///
  /// In es, this message translates to:
  /// **'Semana anterior'**
  String get statsWeekPreviousTooltip;

  /// Tooltip del botón para ir a la semana siguiente
  ///
  /// In es, this message translates to:
  /// **'Semana siguiente'**
  String get statsWeekNextTooltip;

  /// Título que aparece en el selector de rango de fechas
  ///
  /// In es, this message translates to:
  /// **'Selecciona un rango de fechas'**
  String get statsRangePickerTitle;

  /// Mensaje de error cuando el rango supera los 30 días
  ///
  /// In es, this message translates to:
  /// **'Selecciona un máximo de 30 días.'**
  String get statsRangeTooLongMessage;

  /// Etiqueta para indicar el total semanal
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get statsMetricTotalLabel;

  /// Etiqueta para el promedio diario
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get statsMetricDailyAverageLabel;

  /// Etiqueta que indica el valor predominante
  ///
  /// In es, this message translates to:
  /// **'Predomina'**
  String get statsMetricDominantLabel;

  /// Texto que se muestra cuando no hay datos
  ///
  /// In es, this message translates to:
  /// **'—'**
  String get statsMetricEmptyValue;

  /// Título de la métrica de conteo de tomas de biberón
  ///
  /// In es, this message translates to:
  /// **'Número de tomas'**
  String get statsFeedingCountTitle;

  /// Título de la métrica de volumen de biberón
  ///
  /// In es, this message translates to:
  /// **'Volumen diario'**
  String get statsFeedingVolumeTitle;

  /// Título de la métrica de conteo de pañales
  ///
  /// In es, this message translates to:
  /// **'Cambios de pañal'**
  String get statsDiaperCountTitle;

  /// Título de la métrica de consistencia promedio
  ///
  /// In es, this message translates to:
  /// **'Consistencia promedio'**
  String get statsDiaperConsistencyTitle;

  /// Título de la métrica de conteo de baños
  ///
  /// In es, this message translates to:
  /// **'Sesiones de baño'**
  String get statsBathCountTitle;

  /// Título de la métrica de conteo de vómitos
  ///
  /// In es, this message translates to:
  /// **'Episodios de vómito'**
  String get statsVomitCountTitle;

  /// Título de la métrica de intensidad de vómitos
  ///
  /// In es, this message translates to:
  /// **'Intensidad promedio'**
  String get statsVomitIntensityTitle;

  /// Etiqueta para caca líquida
  ///
  /// In es, this message translates to:
  /// **'Líquida'**
  String get statsConsistencyLiquid;

  /// Etiqueta para caca blanda
  ///
  /// In es, this message translates to:
  /// **'Blanda'**
  String get statsConsistencySoft;

  /// Etiqueta para caca firme
  ///
  /// In es, this message translates to:
  /// **'Firme'**
  String get statsConsistencyFirm;

  /// Etiqueta del eje Y para número de veces
  ///
  /// In es, this message translates to:
  /// **'Veces'**
  String get statsChartYAxisTimes;

  /// Etiqueta del eje Y para volumen
  ///
  /// In es, this message translates to:
  /// **'Mililitros'**
  String get statsChartYAxisVolume;

  /// Etiqueta del eje Y para consistencia
  ///
  /// In es, this message translates to:
  /// **'Consistencia'**
  String get statsChartYAxisConsistency;

  /// Etiqueta del eje Y para la intensidad del vómito
  ///
  /// In es, this message translates to:
  /// **'Intensidad'**
  String get statsChartYAxisIntensity;

  /// Texto de la leyenda para las barras
  ///
  /// In es, this message translates to:
  /// **'Período seleccionado'**
  String get statsChartLegendSelected;

  /// Texto de la leyenda para la línea de tendencia
  ///
  /// In es, this message translates to:
  /// **'Línea de tendencia'**
  String get statsChartLegendTrend;

  /// Mensaje cuando no existen datos en la semana seleccionada
  ///
  /// In es, this message translates to:
  /// **'Aún no hay registros en esta semana.'**
  String get statsEmptyState;
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
