Inventory system zawiera informacje o gemach oraz narzędziach aktualnie posiadanych przez graczy.
Typy danych to 
```json
Gem{
	passive: Scene,
	description: String,
	type: Enum[Exception, Inclusion, Main, Colorless],
	identity: Enum[Warrior, Writer, Wanderer]
},

Tool{
	Rune: Scene,
	Pattern: Array[int], ## gdzie (0, 1, 2, 3) -> (lewo, góra, dół, prawo)
	CD: float,
	Description: String
}
```
Pozwala na ustawienie buildu na postaci w momencie resetów(pod koniec edycji lub wymuszenia buildu) tzn. ustaleniu pasywek oraz aktywnych umiejętności.

Możliwość edycji danych przy głównych checkpointach lub przy wyznaczonych obszarach koło sklepu przed levelem.

Interface składa się z dwóch elementów: UI do wybierania co zamienić (a) oraz wyszukiwarki pozwalającej na wybranie na co zamienić (b).

Interface (a):
Składa się z dwóch grup po cztery elementy
Pierwsza grupa zawiera 4 narzędzia.
Druga grupa zawiera 1 Gem główny oraz 3 gemy dodatkowe składające się na passywne efekty gracza.

Interface (b):
W zależności od tego co wybrane pokazuje możliwe dostępne elementy według build restriction.
Główny gem dyktuje jakie pozostałe runy są dostępne. W slot z narzędziami nie jest możliwe dodawanie gemów i wicewersa.
