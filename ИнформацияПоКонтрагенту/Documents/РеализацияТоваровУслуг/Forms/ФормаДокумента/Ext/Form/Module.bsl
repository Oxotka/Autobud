﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура КУТ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	УстановитьЗадолженностьКлиента();
	
КонецПроцедуры

&НаКлиенте
Процедура КУТ_ОбработкаНавигационнойСсылкиПеред(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВзаиморасчетыПоОрганизации" Тогда
		СтандартнаяОбработка = Ложь;
		
		УсловияОтбора = Новый Структура("Партнер, Организация", Объект.Партнер, Объект.Организация);
		ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", УсловияОтбора, Истина);
	
		ОткрытьФорму("Отчет.РасчетыСКлиентами.Форма", ПараметрыФормы, ЭтотОбъект);  
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Взаиморасчеты" Тогда
		СтандартнаяОбработка = Ложь;
		
		УсловияОтбора = Новый Структура("Партнер", Объект.Партнер);
		ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", УсловияОтбора, Истина);
	
		ОткрытьФорму("Отчет.РасчетыСКлиентами.Форма", ПараметрыФормы, ЭтотОбъект);  
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КУТ_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗадолженностьКлиента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КУТ_ПартнерПриИзмененииПосле(Элемент)
	
	УстановитьЗадолженностьКлиента();
	
КонецПроцедуры

&НаКлиенте
Процедура КУТ_ОрганизацияПриИзмененииПосле(Элемент)
	
	УстановитьЗадолженностьКлиента();
	
КонецПроцедуры

&НаКлиенте
Процедура КУТ_ПартнерБезКЛПриИзмененииПосле(Элемент)
	
	УстановитьЗадолженностьКлиента();
	
КонецПроцедуры

&НаКлиенте
Процедура КУТ_ДатаПриИзмененииПосле(Элемент)
	
	УстановитьЗадолженностьКлиента();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗадолженностьКлиента()
	
	Обработки.ЗадолженностьПартнеров.УстановитьЗадолженностьКлиента(ЭтотОбъект, Объект);
	
КонецПроцедуры

#КонецОбласти
