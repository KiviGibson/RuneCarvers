# O Projekcie
2 osobowa gra Coop (Local/Steam) z mechanikami RPG inspirowana twórczością Hazel light studio (It takes two oraz A way out) oraz grami takimi jak Helldivers oraz League of legends. 

# Filarami gry będą 
- Walka, [[Przeciwnicy|PvE]] z wykorzystaniem mechaniki [[Rune Carving]] oraz [[Effect system|Efektów statusu]].
- Theory Crafting, Przy pomocy [[Forgeing and build management|mechaniki kowalstwa]] (w wyznaczonych obszarch gry) gracz może wykonywać kolejne narzędzia do grawerowania, wykonywać testów na manekinach jak i łączenia ich z pasywnymi efektami (działającymi jak runy z league of legends).
- Eksploracja, pozwalająca na otrzymywanie dodatkowych zasobów jak i umożliwiających wykonywanie side-questów ([[mapa demo]]).
- Różnorodne wykorzystanie mechaniki skrawania do zagadek środowiskowych.
# Expirience my balls
Przyjemna oraz wymagająca walka (responsywna!).
Effect design na poziomie.
Build theory crafting jest wynagradzający.
Wygodna oraz nagradzająca eksploracja z przyjemnymi minigrami.

# Core gameplay
Gra podzielona jest na segmenty małych/średnich lokacji rozdzielonych (kuźniami) miejscami na zmiane buildu. Gracz wykonuje kolejne kroki: 
1. Zmienia oraz testuje build razem z drugą osobą
2. Przechodzi do kolejnego poziomu dokonując eksploracji oraz pokonując kolejnych przeciwników.
3. Każda z lokacji posiada serie (2 subquesty) zadań otrzymanych przed wejściem do obszaru np. pokonać specyficznych przeciwników/ znaleźć i donieść przedmiot do zadanej lokalizacji.
4. Mapa kończy się bossem lub areną ze zwiększonym wyzwaniem, testującym umiejętności graczy
Ukończenie subquestów daje dodatkowe bonusy oraz wpływają na fabułę

# Założenia
Utworzenie [[Główne Mechaniki#^8e17e3|systemów]] pozwających na wyodrębnienie segmentów kodu i pozwalające na interakcję poprzez zdefiniowane interfejsy (wyjścia systemów). Systemy w założeniu posiadają własne datatype'y oraz metody ich przechowywania zdefiniowane w dokumentacji Godota.

Wygodne oraz intuicyjne UI pozwalające na szybką identyfikacje działania systemu walki budowania buildów oraz interakcji ze środowiskiem.
![[Pasted image 20260709154251.png]]

Gra 3D stylizowana na wygląd gry Tunic. Świat przedstawiony to wyspy zawieszone na niebie łączone poprzez mosty zwodzone przypominające gry z serii Skylanders. Do przemieszczania się stosowanne balonopodobne pojazdy.
![[Pasted image 20260709154407.png]]
![[Pasted image 20260709154419.png]]
![[Pasted image 20260709154546.png]]
![[Pasted image 20260709154602.png]]

# Mechaniki
Mechaniki są zawarte w: [[Główne Mechaniki]]. 
# Level'e
Poziom dzieli się na sekcje walki z eksploracją, Sklep z możliwością zmiany buildu
# User interface
1. [[Game overlay]]
2. [[Pause Menu]]
3. [[Dialogue system]]
4. [[Forgeing and build management]]
# Sterowanie
Możliwe modyfikacje
Poruszanie się: WSAD oraz lewa gałka kontrolera
Celowanie: Pozycja myszy lub prawy drążek
Wejdź w stan rycia(Hold/ Switch): RMB lub Prawy-Zderzak
Aktywacja Poprawnej/ Aktywnej Runy: LMB lub Prawy-spust 
Klawisze ryjące(stan rycia): WSAD lub XYAB (dla Xbox)
Interakcja ze środowiskiem: F lub X (dla Xbox)
Bieg: Shift lub A (dla Xbox)
Wyjście do menu pauzy: Esc lub start
# Milestone
Utworzenie input systemu oraz możliwości łączenia się poprzez localhost.
Wykonanaie kolejnych systemów pozwalających na utworzenie pełnego game-loop.
1. Carving System (Done)
2. Inventory System (Działa nie skończone)
3. Stat Sustem (Done)
4. Połączenie Inventory z Carving systemem
5. Movement System (Done)
6. Bridge pomiędzy systemami
7. Podstawowy System Damage'a (Done)
8. Enemy AI (Done)
9. Pierwszy Boss z interakcjami różnych systemów
10. Zagadki coop oraz competetive (competetive finished)
Utworzenie demo level'a wraz z możliwością prezentacji wszystkich mechanik zaimplementowanych.

