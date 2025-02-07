# Softwareentwicklung und Softwarebibliotheken

## 12.09.2024

C und C++

Beide Sprachen brauchen Bibliotheken um zu funktionieren.

Compiler weiß ohne Headerfiles nichts von Bibliotheken. Präprozessor erzeugt über Includes eine Datei die die Headerfiles einbindet, dass der Compiler Fehler in der Verwendung von Bibliotheken anzeigen kann.

## 13.09.2024

Wir nutzen GCC als Compiler. Man kann mit Optionen bestimmen welche Schritte gemacht werden sollen.

Kommentare waren bis C99 nur mit /\*\*/ möglich(danach auch mit //) Man kann Kommentare nicht Schachteln. Man kann nur mit #if(1) Bereiche mit Kommentaren auskommentieren.

C verwended normalerweise snake_case verwendet. C ist Case-sensitive.

Linker sind Programmiersprachen unabhängig.

Namen können beliebig lange sein. Es wurden aber nur die ersten 31 Zeichen berücksichtigt. Bei externen Namen werden nur 6 Buchstaben berüksichtigt => daher die Namen strlen oder strcmp. Der Linker ist case-insensitive.

INTEGER ist in Pascal kein Schlüsselwort, int in C schon.

Wir verwenden C89/90 da C++ sich daraus entwickelt hat.

C ist statisch typisiert, Variablen müssen beim Kompilieren schon bekannt sein. Bei dynamischer Typisierung ist nicht gegeben, dass eine Variable einen fixen Datentyp hat.

Werte skalarer Datentypen können nicht aufgeteilt werden in mehrere Teile. Werte strukturierter Datentypen bestehen aus mehreren Werten.

Chars und Enums sind in C arthmetisch, also kann man damit rechnen.

Nicht alles was in C erlaubt ist ist schlau.

Mit Pointer kann man nur beschränkt rechnen, also nur addieren und subtrahieren.

Void ist ein Datetyp ohne Werte. Man benutzt ihn um eine Funktion ohne Rückgabewert zu definieren.

C hat kein bool, int = 0 ist false der int != 0 ist true.

Immer ein bool selbst definieren mit

``` C
typedef        /*0      1*/
    enum bool {false, true} bool;
```

011 != 11 da 0 vorne octalzahl heißt. Hexadezimal = 0x...

## Klausurinfos

90 Minuten keine Unterlagen

Tipp: Bleistift, Radierer und Textmarker(Also lange Angaben)

Noten werden an Durchschnittliche Punkte angepasst. 12/24 reichen aber fix für einen 4er.

Aufgaben wie bei Kurztest. C und C++ Aufgaben.

24 Punkte, circa so aufgeteilt:

### C - ca. 8 Punkte

Nicht alles aus Standardbibliothek.

- Felder
- Zeiger
- malloc, free
- string funktionen(strcpy, strncpy, strcmp...)

### C++ - ca. 16 Punkte

- Klasse String
- OOP
  - Vererbung
- Kein Backtracking oder Optimierung
- Keine Minilib
- Keine Generische Programmierung

### Theorie - 2-4 Punkte

Vielleicht ein paar Verständnisfragen. z.B. Namespaces

Keine Namespaces oder Includes gebraucht.

Vector erlaubt, falls man ihn braucht.

Keine extra Zettel gebraucht

RTTI als Theoriefrage

Iteratoren nicht, Lambdas erlaubt aber nicht gefragt wahrscheinlich

### Beispiel

C Datentyp für einfach verkettete Liste existiert.
Funktion für Umwandlungen zwischen Array und Liste gefragt.
