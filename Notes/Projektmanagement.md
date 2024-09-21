# Moderne Entwicklungsprozesse und Werkzeuge

## 13.09.2024

Kunde sollte nicht direkt eingebunden werden, sondern über einen Produktverantwortlichen.

Maximal 3 Projekte pro Projektleiter

Anforderung vs Aufgabe => Was wollen wir? vs Wie machen wir das?

Nicht mehr wie 3 Mitarbeiter pro Aufgabe.

## 14.09.2024

Git ist entstanden da man für frühere Version Management Systeme immer eine Internetverbindung brauchte.

Für Hersteller sind Messen in ihrer Branche oft entscheidend

### Git

Folien übersichltich.

## 21.09.2024

Git restore zum unstagen

git diff => letzter commit vs working tree

git diff --caches => letzter commit vs staging

git diff \<commithash> \<commithash> => vergleicht Commits, man kann auch Branchnamen nutzen

Mit switch oder checkout kann man branches wechseln. Checkout ist deprecated, man sollte switch verwenden.

main~\<Zahl> => Wie viele commits zurück(parents)
main^\<Zahl> => Parent n-ten grades(bei merge gibt es 2 parents, mehr sind möglich)
main^2~3 => Zweiter Parent und noch 3 Commits zurück

git reset --soft => setzt den branch pointer zurück auf einen vergangenen Commit und lasst die changes im staging. --hard löscht die Änderungen

interactive rebasing ist sehr mächtig

Mit normalen rebases kann man seine Historie als einzelne Linie erstellen

NEVER REBASE A SHARED BRANCH

Github einrichten
