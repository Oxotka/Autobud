﻿
&НаКлиенте
Процедура Себестоимость_ЗаполнитьЦеныПоСебестоимостиПеред(Команда)
	Себестоимость_ЗаполнитьЦеныПоСебестоимостиПередНаСервере();
КонецПроцедуры

&НаСервере
Процедура Себестоимость_ЗаполнитьЦеныПоСебестоимостиПередНаСервере()
	
	ТаблицаТовары = РеквизитФормыВЗначение("Объект.Товары");
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВТ_Товары", ТаблицаТовары.Выгрузить());
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Период", Новый Граница(Объект.Дата,ВидГраницы.Включая)); // Получим остатки за секунду до.
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Серия
	|ПОМЕСТИТЬ ТаблицаНоменклатуры
	|ИЗ
	|	&ВТ_Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Серия,
	|	АналитикаУчетаНоменклатуры.КлючАналитики
	|ПОМЕСТИТЬ АналитикаУчета
	|ИЗ
	|	ТаблицаНоменклатуры КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|		ПО Товары.Номенклатура = АналитикаУчетаНоменклатуры.Номенклатура
	|			И Товары.Характеристика = АналитикаУчетаНоменклатуры.Характеристика
	|			И Товары.Серия = АналитикаУчетаНоменклатуры.Серия
	|			И (&Склад = АналитикаУчетаНоменклатуры.Склад)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АналитикаУчета.НомерСтроки,
	|	АналитикаУчета.Номенклатура,
	|	АналитикаУчета.Характеристика,
	|	АналитикаУчета.Серия,СебестоимостьТоваровОстатки.КоличествоОстаток,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(СебестоимостьТоваровОстатки.КоличествоОстаток, 0) = 0
	|			ТОГДА 0
	|		ИНАЧЕ ЕСТЬNULL(СебестоимостьТоваровОстатки.СтоимостьОстаток, 0) / СебестоимостьТоваровОстатки.КоличествоОстаток
	|	КОНЕЦ КАК Себестоимость
	|ИЗ
	|	АналитикаУчета КАК АналитикаУчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров.Остатки(
	|				&Период,
	|				Организация = &Организация) КАК СебестоимостьТоваровОстатки
	|		ПО АналитикаУчета.КлючАналитики = СебестоимостьТоваровОстатки.АналитикаУчетаНоменклатуры";
	
	ТаблицаССебестоимостью = Запрос.Выполнить().Выгрузить();
	ТаблицаССебестоимостью.Индексы.Добавить("НомерСтроки");
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
	СтруктураДействий = Новый Структура( // Структура действий с измененными строками
		"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
		"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы);
	
	КэшированныеЗначения = Неопределено;
	
	Для Каждого СтрокаТаблицыТовары Из ТаблицаТовары Цикл
		СтруктураОтбора = Новый Структура("НомерСтроки", СтрокаТаблицыТовары.НомерСтроки);
		СтрокаСебестоимости = ТаблицаССебестоимостью.НайтиСтроки(СтруктураОтбора)[0];
		СтрокаТаблицыТовары.Цена = СтрокаСебестоимости.Себестоимость;
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицыТовары, СтруктураДействий, КэшированныеЗначения);
	КонецЦикла;
	
КонецПроцедуры
