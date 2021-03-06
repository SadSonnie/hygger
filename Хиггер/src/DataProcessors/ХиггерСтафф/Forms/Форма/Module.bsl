
&НаКлиенте
Процедура Добавить(Команда)
	ДобавитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаСервере()
	Сообщить("Успешно добавлен пользователь " + ИДПользователя + " на доску " + ИДДоски);
КонецПроцедуры

&НаКлиенте
Процедура ShowBoards(Команда)
	ShowBoardsНаСервере();
КонецПроцедуры

&НаСервере
Процедура ShowBoardsНаСервере()
	Сообщить("Шоу боардс");
	
	JSONЗапрос = Новый ЗаписьJSON;
	JSONЗапрос.УстановитьСтроку();
	//ИнтернетПрокси = Новый ИнтернетПрокси(Ложь);
	//ИнтернетПрокси.Установить("https", "proxy", 5558, "antufiev.d.o", "fL9c2WB7", );
	ЗаголовокЗапросаHTTP = Новый Соответствие;
	ЗаголовокЗапросаHTTP.Вставить("Content-Type", "application/json");
	АдресРесурса = "/public-api/boards?company_id=" + Константы.КомпаниИД.Получить();
	Соединение = Новый HTTPСоединение("api.hygger.io", 443, , , , , Новый ЗащищенноеСоединениеOpenSSL); //тут 5 параметром прокси должен быть если работа из офиса
	Запрос = Новый HTTPЗапрос(АдресРесурса, ЗаголовокЗапросаHTTP);
	Запрос.Заголовки.Вставить("Authorization", "Bearer " + Константы.АксесТокен.Получить());
	РезультатЗапроса = Соединение.ВызватьHTTPМетод("GET", Запрос);
	Ответ = РезультатЗапроса.ПолучитьТелоКакСтроку();
	ПакетСообщения = main.Разобратьпакет(Ответ);
	ТаблицаДосок = "Доска - id" + Символы.ПС + Символы.ПС;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДоскиХиггер.ИмяДоски,
	|	ДоскиХиггер.ID
	|ИЗ
	|	РегистрСведений.ДоскиХиггер КАК ДоскиХиггер";
	Для Каждого Board Из ПакетСообщения.data Цикл
		ЗаписьЧек = Ложь;
		ТаблицаДосок = ТаблицаДосок + Board.attributes.name + " - " + Board.id + Символы.ПС;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ИмяДоски = Board.attributes.name Тогда
				ЗаписьЧек = Ложь;
				Прервать;
			КонецЕсли;
			ЗаписьЧек = Истина;
		КонецЦикла;
		Если ЗаписьЧек Тогда
			Запись = РегистрыСведений.ДоскиХиггер.СоздатьМенеджерЗаписи();
			Запись.ИмяДоски = Board.attributes.name;
			Запись.ID = Board.id;
			Запись.Записать();
			Сообщить("Добавлена доска " + Board.attributes.name);
		КонецЕсли;
	КонецЦикла;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Для Каждого Board Из ПакетСообщения.data Цикл
			Если Выборка.ИмяДоски = board.attributes.name Тогда
				УдалитьЧек  = Ложь;
				Прервать;
			КонецЕсли;
			УдалитьЧек = Истина;
		КонецЦикла;
		Если УдалитьЧек Тогда
			Запись = РегистрыСведений.ДоскиХиггер.СоздатьМенеджерЗаписи();
			Запись.ИмяДоски = Выборка.ИмяДоски;
			Запись.ID = Выборка.ID;
			Запись.Удалить();
		КонецЕсли;
	КонецЦикла;
	Вывод = ТаблицаДосок;
	
КонецПроцедуры

&НаКлиенте
Процедура ShowMembers(Команда)
	ShowMembersНаСервере();
КонецПроцедуры

&НаСервере
Процедура ShowMembersНаСервере()
	Сообщить("Шоу мемберс");
	
	JSONЗапрос = Новый ЗаписьJSON;
	JSONЗапрос.УстановитьСтроку();
	//ИнтернетПрокси = Новый ИнтернетПрокси(Ложь);
	//ИнтернетПрокси.Установить("https", "proxy", 5558, "antufiev.d.o", "fL9c2WB7", );
	ЗаголовокЗапросаHTTP = Новый Соответствие;
	ЗаголовокЗапросаHTTP.Вставить("Content-Type", "application/json");
	АдресРесурса = "/public-api/users?company_id=" +Константы.КомпаниИД.Получить();
	Соединение = Новый HTTPСоединение("api.hygger.io", 443, , , , , Новый ЗащищенноеСоединениеOpenSSL); //тут 5 параметром прокси должен быть если работа из офиса
	Запрос = Новый HTTPЗапрос(АдресРесурса, ЗаголовокЗапросаHTTP);
	Запрос.Заголовки.Вставить("Authorization", "Bearer " + Константы.АксесТокен.Получить());
	РезультатЗапроса = Соединение.ВызватьHTTPМетод("GET", Запрос);
	Ответ = РезультатЗапроса.ПолучитьТелоКакСтроку();
	ПакетСообщения = main.Разобратьпакет(Ответ);
	СписокМембер = "Member - id" + Символы.ПС + Символы.ПС;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	УчастникиХиггер.ИмяУчастника,
	|	УчастникиХиггер.ID
	|ИЗ
	|	РегистрСведений.УчастникиХиггер КАК УчастникиХиггер";
	Для Каждого Member Из ПакетСообщения.data Цикл
		ЗаписьЧек = Ложь;
		СписокМембер = СписокМембер + Member.attributes.fullname + " - " + Member.id + Символы.ПС;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ИмяУчастника = Member.attributes.fullname Тогда
				ЗаписьЧек = Ложь;
				Прервать;
			КонецЕсли;
			ЗаписьЧек = Истина;
		КонецЦикла;
		Если ЗаписьЧек Тогда
			Запись = РегистрыСведений.УчастникиХиггер.СоздатьМенеджерЗаписи();
			Запись.ИмяУчастника = Member.attributes.fullname;
			Запись.ID = Member.id;
			Запись.Записать();
			Сообщить("Добавлен пользователь " + Member.attributes.fullname);
		КонецЕсли;
	КонецЦикла;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Для Каждого Member Из ПакетСообщения.data Цикл
			Если Выборка.ИмяУчастника = Member.attributes.fullname Тогда
				УдалитьЧек  = Ложь;
				Прервать;
			КонецЕсли;
			УдалитьЧек = Истина;
		КонецЦикла;
		Если УдалитьЧек Тогда
			Запись = РегистрыСведений.УчастникиХиггер.СоздатьМенеджерЗаписи();
			Запись.ИмяУчастника = Выборка.ИмяУчастника;
			Запись.ID = Выборка.ID;
			Запись.Удалить();
		КонецЕсли;
	КонецЦикла;
	Вывод = СписокМембер;
	
КонецПроцедуры


