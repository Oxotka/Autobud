﻿
&НаКлиенте
Процедура Печать(Команда)
	ПечатьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПечатьНаСервере()
	ОбъектОбъект = РеквизитФормыВЗначение("Объект");
	ТабличныйДокумент = ОбъектОбъект.СформироватьПечатнуюФормуЗаказНаПеремещение(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Заказ), Неопределено);
КонецПроцедуры
