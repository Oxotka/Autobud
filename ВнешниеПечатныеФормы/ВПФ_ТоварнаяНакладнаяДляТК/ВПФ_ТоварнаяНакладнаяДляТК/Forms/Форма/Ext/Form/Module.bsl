﻿
&НаКлиенте
Процедура Печать(Команда)
	ПечатьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПечатьНаСервере()
	ОбъектОбъект = РеквизитФормыВЗначение("Объект");
	МассивОбъектов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Документ);
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	ПараметрыПечати = Новый Структура("ВыводитьУслуги", Ложь);
	ТабличныйДокумент = ОбъектОбъект.СформироватьПечатнуюФормуТОРГ12(СтруктураТипов, Неопределено, ПараметрыПечати, Неопределено);
КонецПроцедуры
