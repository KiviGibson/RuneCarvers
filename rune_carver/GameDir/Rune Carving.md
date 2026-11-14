# TL; DR
Player holds runecarving tools that allows him to make signs on stone that gives it power to exterminate, heal and alter reality.

# Założenie systemu
System ma powodować taktyczne decyzje poprzez dobieranie ataków pozwalających na wykazanie się zręcznością oraz wyczuciem dla danej sytuacji. Umiejętności mają pozwalać na współpracę. Rozwinięcie systemu Strategem do głównej mechaniki walki. 
![[Pasted image 20260709155422.png]]
# Systemy
1. Input System pozwalający na granie w dwie osoby jako local/couch (DONE)
2. System do wykonywania run, Przełączania po między stanami oraz odczytywania kombinacji (DONE)
3. (System\Interface Inventory) umożliwiający odczytanie aktualnie posiadanych narzędzi, Loudout (In production)
4. Interface do interakcji z overlayem gry do wskazywania danych

# Działanie
Gracz może wybrać do czterech narzędzi pozwalających na rycie. 
Przełączając się do stanu rycia może rozpocząć wprowadzanie sekwencji rycin. 
Po wprowadzeniu poprawnej kombinacji oraz wyjściu ze stanu rycia gracz otrzymuje runę do używania, która posiada ładunki. 
Można przerwać aktywną runę poprzez przejście do stanu rycia.
Jeżeli żadna z kombinacji nie jest poprawnie wprowadzona rycie się resetuje dając możliwość na szybkie rozpoczęcie rycia od początku.
# Bazowe typy
Elektryczne - efekty pozwalające na zadanie bonusowych obrażeń poprzez kombinacje pozytywnej i negatywnej energii
Lodowe - sumon roślin ataki pozwalające na zmniejszenie obrażeń
Ziemne - leczenie efekty pozwalające na sustain oraz efekt frostbite
Ogniste - podpalenie prokujące dodatkowe efekty przy podtrzymywaniu go na wrogach

# Trzy tryby
Trzy bazowe tryby:
Semi gdzie po kliknięciu wywołujemy działanie runy
Hold przytrzymanie powoduje rozpoczęcie ładunków co kilka ładunków wystrzeliwuje pocisk
Charge atak ładowany dodający moc z przytrzymaniem, NEXT Można dodać system pozwalający na sweet spoty.

[[Koncepty ataków]]