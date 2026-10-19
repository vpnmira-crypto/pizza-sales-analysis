# Fragen und Antworten — Pizza Sales Analysis 2015

## 1. Wie hoch sind der Gesamtumsatz, die Anzahl der Bestellungen, die Zahl der verkauften Pizzen, der durchschnittliche Bestellwert und die durchschnittliche Anzahl der Pizzen pro Bestellung?

Der Gesamtumsatz beträgt **817.860,05 Dollar**. Es gab **21.350 Bestellungen**, und insgesamt wurden **49.574 Pizzen** verkauft. Der durchschnittliche Bestellwert beträgt **38,31 Dollar** (Umsatz geteilt durch Bestellungen). Im Durchschnitt enthält eine Bestellung **2,32 Pizzen**.

## 2. Wie entwickelte sich der Umsatz im Jahresverlauf, und welcher Monat war am stärksten bzw. am schwächsten?

Der stärkste Monat war **Juli** mit **72.557,90 Dollar Umsatz**. Der schwächste Monat war **Oktober** mit **64.027,60 Dollar Umsatz**. Mit der SQL-Funktion `LAG()` wurde die Umsatzveränderung gegenüber dem jeweiligen Vormonat berechnet.

## 3. An welchen Wochentagen und zu welchen Uhrzeiten war die Nachfrage besonders hoch bzw. niedrig?

Am stärksten war **Freitag** mit durchschnittlich **70,76 Bestellungen pro Freitag**, am schwächsten **Sonntag** mit **50,46 Bestellungen pro Sonntag**. Die Nachfragespitzen lagen zwischen **12:00 und 13:00 Uhr** sowie zwischen **17:00 und 19:00 Uhr**. Die stärkste Kombination war **Donnerstag um 13:00 Uhr** mit insgesamt **438 Bestellungen im Jahr**. Diese Zeiten sind für die Personalplanung besonders wichtig.

## 4. Welche Pizzen waren die Bestseller, welche verkauften sich am schwächsten, und überschneiden sich die Ranglisten?

Den höchsten Umsatz erzielte **The Thai Chicken Pizza** mit **43.434,25 Dollar**. Nach Stückzahl lag **The Classic Deluxe Pizza** mit **2.453 verkauften Pizzen** vorn. Die Top-5 nach Umsatz und nach Stückzahl überschneiden sich bei drei Pizzen: **The Thai Chicken Pizza, The Barbecue Chicken Pizza und The Classic Deluxe Pizza**. Am schwächsten in beiden Kennzahlen war **The Brie Carre Pizza** mit **490 Pizzen** und **11.588,50 Dollar Umsatz**. Die Ranglisten wurden mithilfe von `RANK()` erstellt.

## 5. Wie verteilt sich der Umsatz auf Kategorien und Größen?

Der Umsatz verteilt sich relativ gleichmäßig auf die Kategorien: **Classic 26,91 %**, **Supreme 25,46 %**, **Chicken 23,96 %** und **Veggie 23,68 %**. Bei den Größen hat **L** mit **45,89 % des Umsatzes** den größten Anteil. Danach folgen **M mit 30,49 %** und **S mit 21,77 %**. **XL** macht **1,72 %** und **XXL** **0,12 %** des Umsatzes aus.

## 6. Welche Pizzen sollten für eine mögliche Streichung von der Speisekarte geprüft werden, und wie hoch ist ihr Umsatzanteil?

Fünf Pizzen wurden für eine genauere Prüfung ausgewählt: **The Brie Carre Pizza, The Green Garden Pizza, The Spinach Supreme Pizza, The Mediterranean Pizza und The Spinach Pesto Pizza**. Zusammen erzielen sie **71.778,50 Dollar Umsatz**, also **8,78 % des Gesamtumsatzes**. Sie sollten **nicht automatisch gestrichen** werden. Vor einer Entscheidung müssen auch Wareneinsatz, Marge, Zutaten und Kundenverhalten geprüft werden.

## 7. Wie wichtig sind große Bestellungen mit vier oder mehr Pizzen?

Bestellungen mit **vier oder mehr Pizzen** machen **18,17 % aller Bestellungen** aus, bringen aber **322.570,90 Dollar Umsatz**. Das sind **39,44 % des Gesamtumsatzes**. Dafür wurde zuerst die Pizzamenge je Bestellung mit SQL zusammengefasst und anschließend mit `CASE` in Gruppen eingeteilt. Das Ergebnis spricht dafür, **Gruppenangebote oder Angebote für Firmen zu testen**.

## 8. Wann sollte eine Werbeaktion getestet werden, und welches Potenzial zeigt das Szenario?

Ein mögliches Testzeitfenster ist **Montag um 22:00 Uhr**. In diesem wöchentlichen Zeitfenster gab es über das Jahr **53 Bestellungen** mit insgesamt **1.869,05 Dollar Umsatz**. Bei einem **Szenario mit 10 % mehr Umsatz** wären das **186,91 Dollar zusätzlich** und **2.055,96 Dollar insgesamt**. **Das ist keine Prognose, sondern ein Rechenbeispiel.** Der tatsächliche Effekt muss in einem Test gemessen werden.
