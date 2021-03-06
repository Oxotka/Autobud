﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ПрограммныйИнтерфейс
&НаСервере
Функция СформироватьНаСервере(ОбъектыПечати)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(СсылкаНаОбъект);
	КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм(Идентификатор);
	ПараметрыВывода = УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода();
	
	ОбработкаОбъект.Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
	МассивПечатныхФорм = ОбщегоНазначения.ТаблицаЗначенийВМассив(КоллекцияПечатныхФорм);
	
	Возврат МассивПечатныхФорм;
	
КонецФункции

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОбъектыПечати = Новый СписокЗначений;
	ОбъектыПечати.Добавить(СсылкаНаОбъект);
	
	МассивПечатныхФорм = СформироватьНаСервере(ОбъектыПечати);
	
	УправлениеПечатьюКлиент.ПечатьДокументов(МассивПечатныхФорм, ОбъектыПечати, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере(Идентификаторы)
	ОбъектОбработка = РеквизитФормыВЗначение("Объект");
	СведенияОРегистрации = ОбъектОбработка.СведенияОВнешнейОбработке();
	Для каждого Сведение Из СведенияОРегистрации Цикл
		Если Сведение.Ключ <> "Команды" И Сведение.Ключ <> "Назначение" И Сведение.Ключ <> "Разрешения" Тогда
			Строка = СведениеООбработке.Добавить();	
			Строка.Сведение = Сведение.Ключ;
			Строка.Параметр = Сведение.Значение;
		ИначеЕсли Сведение.Ключ = "Команды" Тогда 
			Для каждого Команда Из Сведение.Значение Цикл
				ЗаполнитьЗначенияСвойств(КомандыТЗ.Добавить(),Команда );	
				//Элементы.Идентификаторы.СписокВыбора.Добавить(Команда.Идентификатор);
			КонецЦикла;                            
		ИначеЕсли Сведение.Ключ = "Назначение" Тогда 
			Строка.Сведение = Сведение.Ключ;
			Строка.Параметр = ПреобразоватьМассивВСтроку(Сведение.Значение);
			Назначение = Сведение.Значение;		
		ИначеЕсли Сведение.Ключ = "Разрешения" Тогда 
			Строка.Сведение = Сведение.Ключ;
			Строка.Параметр = ПреобразоватьМассивВСтроку(Сведение.Значение);
		КонецЕсли; 	
	КонецЦикла; 
	
	МассивОграниченияТипов = Новый Массив();
	Для каждого НазначениеСсылка Из Назначение Цикл
		ТипСсылки = Лев(НазначениеСсылка, СтрНайти(НазначениеСсылка, ".") - 1) + "Ссылка";
		ПолныйТипСсылка = ТипСсылки + Прав(НазначениеСсылка, СтрДлина(НазначениеСсылка) - СтрНайти(НазначениеСсылка, ".") + 1);
		Попытка
			ТипОбъект = Тип(ПолныйТипСсылка);
		Исключение
			Сообщить("Тип данных """+ ПолныйТипСсылка + """ не найден в конфигурации!");	
		КонецПопытки;
		Если ЗначениеЗаполнено(ТипОбъект) Тогда
			МассивОграниченияТипов.Добавить(ТипОбъект);
		КонецЕсли; 
	КонецЦикла; 
	НашеОписание = Новый ОписаниеТипов(МассивОграниченияТипов);	
	Элементы.СсылкаНаОбъект.ОграничениеТипа = НашеОписание;
	СсылкаНаОбъект = НашеОписание.ПривестиЗначение(СсылкаНаОбъект);
КонецПроцедуры

Функция ПреобразоватьМассивВСтроку(Массив)
	СтрокаВозврата = "";
	Для каждого ЭлементМассив Из Массив Цикл
		СтрокаВозврата = СтрокаВозврата + ?(ЗначениеЗаполнено(СтрокаВозврата),", ", "") + ЭлементМассив;	
	КонецЦикла; 
	Возврат СтрокаВозврата;
КонецФункции
 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере(Идентификатор);
КонецПроцедуры

&НаКлиенте
Процедура КомандыПриИзменении(Элемент)
	//Идентификатор = ТекущийЭлемент.ТекущаяСтрока
	в = 4;
КонецПроцедуры

&НаКлиенте
Процедура КомандыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	а = 3;
КонецПроцедуры

&НаКлиенте
Процедура КомандыПриАктивизацииСтроки(Элемент)
	Идентификатор = КомандыТЗ.НайтиПоИдентификатору(Элемент.ТекущаяСтрока).Идентификатор;
КонецПроцедуры

#КонецОбласти
