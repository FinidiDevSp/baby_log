// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Baby Log';

  @override
  String get homeEditBabyTooltip => 'Editar bebé';

  @override
  String get homeEmptyDescription =>
      'Aquí aparecerán las métricas y registros de tu bebé.';

  @override
  String get homeLogActionsTooltip => 'Acciones del registro';

  @override
  String get homeLogEditAction => 'Modificar registro';

  @override
  String get homeLogDeleteAction => 'Eliminar registro';

  @override
  String get homeLogDeleteSuccess => 'Registro eliminado.';

  @override
  String homeLogDeleteError(Object error) {
    return 'No se pudo eliminar el registro: $error';
  }

  @override
  String get homeLogDeleteConfirmTitle => '¿Eliminar registro?';

  @override
  String get homeLogDeleteConfirmMessage =>
      '¿Quieres eliminar este registro? Esta acción no se puede deshacer.';

  @override
  String get homeLogDeleteConfirmAction => 'Eliminar';

  @override
  String get homeLogDeleteCancelAction => 'Cancelar';

  @override
  String homeLoadError(Object error) {
    return 'No se pudo cargar la información del bebé.\n$error';
  }

  @override
  String get formEditTitle => 'Editar bebé';

  @override
  String get formCreateTitle => 'Registrar bebé';

  @override
  String get formGenderBoy => 'Niño';

  @override
  String get formGenderGirl => 'Niña';

  @override
  String get formGenderBoySemantic => 'Bebé niño';

  @override
  String get formGenderGirlSemantic => 'Bebé niña';

  @override
  String get formNameLabel => 'Nombre del bebé';

  @override
  String get formNameHint => 'Escribe el nombre';

  @override
  String get formNameError => 'El nombre es obligatorio';

  @override
  String get formBirthSection => 'Nacimiento';

  @override
  String get formBirthDateLabel => 'Fecha';

  @override
  String get formBirthDatePlaceholder => 'Selecciona la fecha';

  @override
  String get formBirthTimeLabel => 'Hora';

  @override
  String get formBirthTimePlaceholder => 'Selecciona la hora';

  @override
  String get formBirthDateHelp => 'Fecha de nacimiento';

  @override
  String get formBirthTimeHelp => 'Hora de nacimiento';

  @override
  String get formMeasurementsSection => 'Medidas al nacer';

  @override
  String get formWeightLabel => 'Peso (kg)';

  @override
  String get formWeightHint => 'Ej. 3.20';

  @override
  String get formHeightLabel => 'Altura (cm)';

  @override
  String get formHeightHint => 'Ej. 50.5';

  @override
  String get formInterfaceColorTitle => 'Color de la interfaz';

  @override
  String get formInterfaceColorSubtitle =>
      'Toca para elegir el color de acento.';

  @override
  String get formColorPickerTitle => 'Color de la interfaz';

  @override
  String get formColorPickerConfirm => 'De acuerdo';

  @override
  String get formSheetCloseTooltip => 'Cerrar';

  @override
  String get formSaveButton => 'Guardar';

  @override
  String get formPhotoSheetCamera => 'Tomar foto';

  @override
  String get formPhotoSheetGallery => 'Elegir de la galería';

  @override
  String formPhotoLoadError(Object error) {
    return 'No se pudo cargar la imagen: $error';
  }

  @override
  String get formBirthMissingError => 'Completa la fecha y hora de nacimiento.';

  @override
  String get formUpdateSuccess => 'Perfil actualizado.';

  @override
  String get formCreateSuccess => 'Perfil guardado.';

  @override
  String formSaveError(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get dashboardBottleLabel => 'Biberón';

  @override
  String get dashboardDiaperLabel => 'Caca';

  @override
  String get dashboardVomitLabel => 'Vómito';

  @override
  String get dashboardBathLabel => 'Baño';

  @override
  String get dashboardTemperatureLabel => 'Temperatura';

  @override
  String get dashboardFoodLabel => 'Comida';

  @override
  String get dashboardMedicalAgendaLabel => 'AGENDA';

  @override
  String get agendaTitle => 'Agenda médica';

  @override
  String get agendaNewAppointmentTooltip => 'Agregar cita';

  @override
  String get agendaCreateTitle => 'Nueva cita';

  @override
  String get agendaEditTitle => 'Editar cita';

  @override
  String get agendaFormTitleLabel => 'Título';

  @override
  String get agendaFormTitleError => 'Escribe un título corto';

  @override
  String get agendaFormTypeLabel => 'Tipo de cita';

  @override
  String get agendaFormDateTimeLabel => 'Fecha y hora';

  @override
  String get agendaFormDateTimeError => 'Selecciona la fecha y hora exactas';

  @override
  String get agendaFormNotesLabel => 'Notas';

  @override
  String get agendaFormCancel => 'Cancelar';

  @override
  String get agendaFormSaveNew => 'Guardar cita';

  @override
  String get agendaFormSaveChanges => 'Guardar cambios';

  @override
  String get agendaSectionToday => 'Hoy';

  @override
  String get agendaSectionUpcoming => 'Próximas';

  @override
  String get agendaSectionPast => 'Pasadas';

  @override
  String get agendaPastIndicator => 'Completada';

  @override
  String get agendaEmptyDescription => 'Aún no registraste citas médicas.';

  @override
  String get agendaEditAction => 'Editar';

  @override
  String get agendaDeleteAction => 'Eliminar';

  @override
  String get agendaDeleteConfirmTitle => 'Eliminar cita';

  @override
  String get agendaDeleteConfirmMessage => 'La cita se eliminará de la agenda.';

  @override
  String get agendaDeleteConfirmCancel => 'Conservar';

  @override
  String get agendaDeleteConfirmAccept => 'Eliminar';

  @override
  String get agendaCreateSuccess => 'Cita guardada.';

  @override
  String get agendaUpdateSuccess => 'Cita actualizada.';

  @override
  String get agendaDeleteSuccess => 'Cita eliminada.';

  @override
  String get agendaTypeRevision => 'Revisión';

  @override
  String get agendaTypePediatrics => 'Pediatría';

  @override
  String get agendaTypeVaccines => 'Vacunas';

  @override
  String get agendaTypeEmergency => 'Urgencias';

  @override
  String get dashboardAgendaStatusToday => 'Hoy';

  @override
  String get dashboardAgendaStatusTomorrow => 'Mañana';

  @override
  String dashboardAgendaStatusInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'En $count días',
      one: 'En 1 día',
    );
    return '$_temp0';
  }

  @override
  String dashboardQuestionsPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pendientes',
      one: '$count pendiente',
    );
    return '$_temp0';
  }

  @override
  String get dashboardQuestionsAllClear => 'Al día';

  @override
  String get dashboardElapsedJustNow => 'Justo ahora';

  @override
  String dashboardElapsedMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count mins',
      one: 'Hace 1 min',
    );
    return '$_temp0';
  }

  @override
  String dashboardElapsedHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count h',
      one: 'Hace 1 h',
    );
    return '$_temp0';
  }

  @override
  String dashboardElapsedDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count días',
      one: 'Hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get dashboardEventsEmptyTitle => 'No se encontró información';

  @override
  String get dashboardNavHome => 'Inicio';

  @override
  String get dashboardNavStats => 'Estadísticas';

  @override
  String get dashboardNavTimeline => 'Línea temporal';

  @override
  String get dashboardNavDevelopment => 'Desarrollo';

  @override
  String get dashboardNavAccount => 'Cuenta';

  @override
  String get dashboardSearchTooltip => 'Buscar';

  @override
  String get dashboardNotificationsTooltip => 'Notificaciones';

  @override
  String get dashboardTodayLabel => 'Hoy';

  @override
  String get dashboardChangeDayTooltip => 'Cambiar día';

  @override
  String get dashboardImportTooltip => 'Importar datos';

  @override
  String dashboardImportSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se importaron $count registros correctamente.',
      one: 'Se importó 1 registro correctamente.',
      zero: 'No se importaron registros.',
    );
    return '$_temp0';
  }

  @override
  String dashboardImportError(String reason) {
    return 'No se pudo importar el archivo: $reason';
  }

  @override
  String get dashboardImportReadError =>
      'No se pudo leer el archivo seleccionado.';

  @override
  String get dashboardImportDialogTitle => 'Confirmar importacion';

  @override
  String dashboardImportPreviewTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros.',
      one: '1 registro.',
    );
    return 'El archivo contiene $_temp0';
  }

  @override
  String dashboardImportPreviewNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se crearan $count registros nuevos.',
      one: 'Se creara 1 registro nuevo.',
    );
    return '$_temp0';
  }

  @override
  String dashboardImportPreviewDuplicates(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros coinciden con los existentes.',
      one: '1 registro coincide con los existentes.',
    );
    return '$_temp0';
  }

  @override
  String dashboardImportPreviewIssues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filas tienen errores y se omitiran.',
      one: '1 fila tiene errores y se omitira.',
    );
    return '$_temp0';
  }

  @override
  String get dashboardImportNoData =>
      'El archivo seleccionado no contiene registros.';

  @override
  String get dashboardImportCancelAction => 'Cancelar';

  @override
  String get dashboardImportSkipAction => 'Omitir duplicados';

  @override
  String get dashboardImportOverwriteAction => 'Sobrescribir duplicados';

  @override
  String get dashboardImportConfirmAction => 'Importar registros';

  @override
  String get dashboardExportTooltip => 'Exportar datos';

  @override
  String get dashboardExportEmpty => 'Aun no hay datos para exportar.';

  @override
  String dashboardExportError(String reason) {
    return 'No se pudo exportar la informacion: $reason';
  }

  @override
  String dashboardExportShareSubject(String fileName) {
    return 'Exportacion de Baby Log ($fileName)';
  }

  @override
  String dashboardExportShareBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
    );
    return 'Este CSV incluye $_temp0 exportados desde Baby Log.';
  }

  @override
  String get dashboardPediatricQuestionsLabel => 'Preguntas';

  @override
  String get bottleLogTitle => 'Toma de biberón';

  @override
  String get bottleLogDateTimeLabel => 'Día y hora';

  @override
  String get bottleLogAmountLabel => 'Cantidad';

  @override
  String get bottleLogAmountUnit => 'ml';

  @override
  String get bottleLogNotesLabel => 'Notas';

  @override
  String get bottleLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get bottleLogAmountValidation => 'Introduce una cantidad válida';

  @override
  String get bottleLogDecreaseTooltip => 'Restar 5 ml';

  @override
  String get bottleLogIncreaseTooltip => 'Sumar 5 ml';

  @override
  String get homeLogListTitle => 'Últimos registros';

  @override
  String get bathLogTitle => 'Baño';

  @override
  String get bathLogTypeLabel => 'Tipo de baño';

  @override
  String get bathLogTypeFullOption => 'Completo';

  @override
  String get bathLogTypeQuickOption => 'Rápido';

  @override
  String get bathLogTypeFullDescription => 'Baño completo';

  @override
  String get bathLogTypeQuickDescription => 'Baño rápido';

  @override
  String get bathLogNotesLabel => 'Notas';

  @override
  String get bathLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get stoolLogTitle => 'Cambio de pañal';

  @override
  String get stoolLogDateTimeLabel => 'Día y hora';

  @override
  String get stoolLogConsistencyLabel => 'Consistencia';

  @override
  String get stoolLogConsistencyLiquidOption => 'Líquida';

  @override
  String get stoolLogConsistencySoftOption => 'Blanda';

  @override
  String get stoolLogConsistencyFirmOption => 'Firme';

  @override
  String get stoolLogConsistencyLiquidDescription => 'Caca líquida';

  @override
  String get stoolLogConsistencySoftDescription => 'Caca blanda';

  @override
  String get stoolLogConsistencyFirmDescription => 'Caca firme';

  @override
  String get stoolLogNotesLabel => 'Notas';

  @override
  String get stoolLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get stoolLogConsistencyValidation => 'Selecciona una consistencia';

  @override
  String get vomitLogTitle => 'Registro de vómito';

  @override
  String get vomitLogAmountLabel => 'Cantidad';

  @override
  String get vomitLogAmountLowOption => 'Poca';

  @override
  String get vomitLogAmountMediumOption => 'Media';

  @override
  String get vomitLogAmountHighOption => 'Abundante';

  @override
  String get vomitLogAmountLowDescription => 'Vómito ligero';

  @override
  String get vomitLogAmountMediumDescription => 'Vómito moderado';

  @override
  String get vomitLogAmountHighDescription => 'Vómito abundante';

  @override
  String get vomitLogNotesLabel => 'Notas';

  @override
  String get vomitLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get vomitLogAmountValidation => 'Selecciona una cantidad';

  @override
  String get temperatureLogTitle => 'Temperatura';

  @override
  String get temperatureLogValueLabel => 'Temperatura';

  @override
  String get temperatureLogValueUnit => '°C';

  @override
  String get temperatureLogDecreaseTooltip => 'Restar 0,1 °C';

  @override
  String get temperatureLogIncreaseTooltip => 'Sumar 0,1 °C';

  @override
  String get temperatureLogValueValidation =>
      'Introduce una temperatura válida';

  @override
  String get temperatureLogNotesLabel => 'Notas';

  @override
  String get temperatureLogNotesHint => 'Añade detalles que quieras recordar';

  @override
  String get bottleLogListTitle => 'Últimas tomas';

  @override
  String get questionsTitle => 'Preguntas';

  @override
  String get questionsShareTooltip => 'Compartir preguntas pendientes';

  @override
  String get questionsShareTitle => 'Preguntas para el pediatra';

  @override
  String get questionsShareMessage =>
      'Estas son las dudas que queremos comentar en la próxima visita.';

  @override
  String questionsShareError(Object error) {
    return 'No se pudo compartir: $error';
  }

  @override
  String get questionsValidationMessage =>
      'Escribe tu pregunta antes de guardar.';

  @override
  String questionsSaveError(Object error) {
    return 'No se pudo guardar la pregunta: $error';
  }

  @override
  String questionsUpdateError(Object error) {
    return 'No se pudo actualizar la pregunta: $error';
  }

  @override
  String questionsDeleteError(Object error) {
    return 'No se pudo eliminar la pregunta: $error';
  }

  @override
  String get questionsComposerTitle => 'Anota tu duda';

  @override
  String get questionsComposerPlaceholder =>
      'Ej. Recordar preguntar sobre la introducción de sólidos';

  @override
  String get questionsComposerAction => 'Guardar pregunta';

  @override
  String get questionsComposerUpdateAction => 'Actualizar pregunta';

  @override
  String get questionsComposerEditingNotice => 'Editando una pregunta guardada';

  @override
  String get questionsComposerCancelEditing => 'Cancelar edición';

  @override
  String get questionsPendingSection => 'Pendientes';

  @override
  String get questionsResolvedSection => 'Resueltas';

  @override
  String get questionsDeleteDialogTitle => '¿Eliminar pregunta?';

  @override
  String get questionsDeleteDialogMessage =>
      'La pregunta se quitará de la lista.';

  @override
  String get questionsDeleteDialogConfirm => 'Eliminar';

  @override
  String get questionsEditDialogTitle => 'Editar pregunta';

  @override
  String get questionsEditDialogLabel => 'Pregunta';

  @override
  String get questionsEditDialogCancel => 'Cancelar';

  @override
  String get questionsEditDialogSave => 'Guardar';

  @override
  String get questionsEditAction => 'Editar';

  @override
  String get questionsDeleteAction => 'Eliminar';

  @override
  String get questionsEmptyTitle => 'Anota tus dudas';

  @override
  String get questionsEmptySubtitle =>
      'Guarda las preguntas que quieras llevar a la próxima visita con el pediatra.';

  @override
  String get questionsLoadError =>
      'No se pudieron cargar tus preguntas. Intenta de nuevo.';

  @override
  String get questionsAgeUnknown => 'Edad no disponible';

  @override
  String get questionsAgeLessThanWeek => 'Menos de una semana';

  @override
  String questionsAgeWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '$count semana',
    );
    return '$_temp0';
  }

  @override
  String questionsAgeMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '$count mes',
    );
    return '$_temp0';
  }

  @override
  String questionsAgeMonthsAndWeeks(int months, int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses',
      one: '$months mes',
    );
    String _temp1 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semanas',
      one: '$weeks semana',
    );
    return '$_temp0 y $_temp1';
  }

  @override
  String get questionsSatisfactionTitle => '¿Cómo salió la consulta?';

  @override
  String get questionsSatisfactionSubtitle =>
      'Cuéntanos qué tan conforme quedaste con la respuesta.';

  @override
  String get questionsSatisfactionHappy => 'Contentos';

  @override
  String get questionsSatisfactionNeutral => 'Neutral';

  @override
  String get questionsSatisfactionSad => 'Inconformes';

  @override
  String get questionsSatisfactionNoteLabel => 'Notas adicionales';

  @override
  String get questionsSatisfactionConfirm => 'Guardar';

  @override
  String get questionsSatisfactionCancel => 'Cancelar';

  @override
  String get accountSettingsTitle => 'Mi cuenta';

  @override
  String get accountSettingsSubtitle => 'Gestiona tus preferencias personales.';

  @override
  String get accountLanguageTitle => 'Idioma de la aplicación';

  @override
  String get accountLanguageSubtitle =>
      'Elige el idioma que prefieres para BabyLog.';

  @override
  String get accountLanguageOptionSpanish => 'Español';

  @override
  String get accountLanguageOptionEnglish => 'Inglés';

  @override
  String get accountLanguageApplyHint =>
      'El cambio se aplica al instante y se recuerda para futuras sesiones.';

  @override
  String get statsCategoryFeeding => 'Biberón';

  @override
  String get statsCategoryDiapers => 'Pañal';

  @override
  String get statsCategoryBath => 'Baño';

  @override
  String get statsCategoryVomit => 'Vómito';

  @override
  String statsWeekLabel(Object range) {
    return '$range';
  }

  @override
  String get statsWeekSubtitle => 'Datos de lunes a domingo';

  @override
  String get statsWeekPreviousTooltip => 'Semana anterior';

  @override
  String get statsWeekNextTooltip => 'Semana siguiente';

  @override
  String get statsRangePickerTitle => 'Selecciona un rango de fechas';

  @override
  String get statsRangeTooLongMessage => 'Selecciona un máximo de 30 días.';

  @override
  String get statsMetricTotalLabel => 'Total';

  @override
  String get statsMetricDailyAverageLabel => 'Día';

  @override
  String get statsMetricDominantLabel => 'Predomina';

  @override
  String get statsMetricEmptyValue => '—';

  @override
  String get statsFeedingCountTitle => 'Número de tomas';

  @override
  String get statsFeedingVolumeTitle => 'Volumen diario';

  @override
  String get statsDiaperCountTitle => 'Cambios de pañal';

  @override
  String get statsDiaperConsistencyTitle => 'Consistencia promedio';

  @override
  String get statsBathCountTitle => 'Sesiones de baño';

  @override
  String get statsVomitCountTitle => 'Episodios de vómito';

  @override
  String get statsVomitIntensityTitle => 'Intensidad promedio';

  @override
  String get statsConsistencyLiquid => 'Líquida';

  @override
  String get statsConsistencySoft => 'Blanda';

  @override
  String get statsConsistencyFirm => 'Firme';

  @override
  String get statsChartYAxisTimes => 'Veces';

  @override
  String get statsChartYAxisVolume => 'Mililitros';

  @override
  String get statsChartYAxisConsistency => 'Consistencia';

  @override
  String get statsChartYAxisIntensity => 'Intensidad';

  @override
  String get statsChartLegendSelected => 'Período seleccionado';

  @override
  String get statsChartLegendTrend => 'Línea de tendencia';

  @override
  String get statsEmptyState => 'Aún no hay registros en esta semana.';
}
