&НаСервере
Функция Разобратьпакет(СтрокаJSON) Экспорт
	Попытка
		Чтение = Новый ЧтениеJSON;
		Чтение.УстановитьСтроку(СтрокаJSON);
		Данные = ПрочитатьJSON(Чтение, Ложь, , , , , , , 10000);
		Чтение.Закрыть();
		Возврат Данные;
	Исключение
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
КонецФункции