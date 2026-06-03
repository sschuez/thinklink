# Änderungen an der Website machen / Editing the website

This page is for **non-coders**. You do not need to understand HTML, Git or Jekyll.
You describe the change in plain words, and the assistant makes it, checks it, and
publishes it. Diese Seite ist für **Nicht-Techniker:innen** gedacht.

---

## Erste Einrichtung (nur einmal pro Computer)

Diese Schritte machst du **einmal**, wenn du auf einem neuen Computer beginnst. Danach
brauchst du sie nie wieder. Du brauchst **keine** Programmier- oder GitHub-Kenntnisse —
fast alles erledigt der Assistent für dich. Bleib einfach Schritt für Schritt dran, und
wenn du irgendwo nicht weiterkommst, frag die für die Website verantwortliche Person
(siehe `SETUP.md`).

### Schritt 1 — GitHub-Konto erstellen und Zugang erhalten

GitHub ist der Ort, an dem die Website gespeichert wird. Damit du veröffentlichen darfst,
brauchst du ein Konto und eine Freigabe.

1. Öffne <https://github.com/signup> und erstelle ein kostenloses Konto.
2. Merke dir deinen **Benutzernamen** (username).
3. Schicke diesen Benutzernamen an die für die Website verantwortliche Person. Sie gibt
   dir die Schreibrechte.
4. Du bekommst eine **Einladung per E-Mail** (oder auf github.com oben rechts bei der
   Glocke). Klicke darin auf **Accept invitation** / **Einladung annehmen**.

### Schritt 2 — Claude-App herunterladen und anmelden

1. Öffne <https://claude.ai/download> und lade die App für deinen Computer herunter
   (macOS oder Windows).
2. Installiere sie wie jedes andere Programm: heruntergeladene Datei öffnen und den
   Anweisungen folgen.
3. Starte Claude und melde dich an (oder erstelle dort ein Konto, falls nötig).

### Schritt 3 — Die Website auf deinen Computer holen (das macht der Assistent)

Ab hier übernimmt der Assistent. Du tippst nur und bestätigst hin und wieder ein Fenster.

1. Erstelle auf deinem Computer einen leeren Ordner, z. B. `ThinkLink` in deinen
   **Dokumenten**.
2. Öffne in der Claude-App den **Code-/Projekt-Bereich** (Claude Code) und wähle diesen
   Ordner als Arbeitsort aus. *(Wenn du den Bereich nicht findest, frag den Assistenten:
   „Wie öffne ich hier ein Projekt?“)*
3. Schreib dem Assistenten:
   > „Bitte hole die ThinkLink-Website von https://github.com/sschuez/thinklink auf
   > diesen Computer und richte alles ein.“
4. Der Assistent lädt die Website herunter und installiert die nötigen Programme. Dabei
   bittet er dich evtl. um Folgendes — folge einfach den Hinweisen am Bildschirm:
   - ein **Installationsfenster bestätigen** (auf dem Mac z. B. „Befehlszeilentools“);
   - dein **Computer-Passwort eingeben** (für Installationen — das ist normal);
   - dich **bei GitHub anmelden**: Es öffnet sich ein Browserfenster — dort mit deinem
     GitHub-Konto anmelden und bestätigen.
5. Falls der Assistent dich bittet, den Ordner **`thinklink`** zu öffnen (er entsteht
   beim Herunterladen), tu das im Code-/Projekt-Bereich — und schreib dann:
   „Richte diesen Computer ein.“
6. Wenn der Assistent meldet, dass alles **bereit** ist, bist du fertig. 🎉

> **Beim nächsten Mal** brauchst du diese Einrichtung nicht mehr: Du öffnest einfach die
> Claude-App, öffnest den **ThinkLink-Ordner**, und schreibst, was du ändern möchtest
> (siehe unten). Der Assistent prüft beim Start kurz selbst, ob alles bereit ist.

---

## Deutsch

### So machst du eine Änderung

1. Öffne **Claude Code** in diesem Projektordner (`thinklink`) — entweder im Terminal,
   in der Claude-Desktop-App oder auf [claude.ai/code](https://claude.ai/code).
2. Schreib in normalem Deutsch (oder Englisch), was du geändert haben möchtest.
3. Der Assistent ändert die Datei(en) und prüft, dass die Website noch ohne Fehler lädt.

### Vorschau ansehen und veröffentlichen

Nichts geht online, bevor du es gesehen und freigegeben hast. Vor der Vorschau prüft
der Assistent automatisch, dass die Website lädt und alle Links und Bilder
funktionieren — falls etwas kaputt ist, wird es zuerst repariert. Hat in der
Zwischenzeit jemand anderes etwas geändert, holt der Assistent zuerst die aktuelle
Version, damit sich eure Änderungen nicht gegenseitig überschreiben. Der Ablauf:

1. **Vorschau.** Der Assistent startet eine lokale Vorschau und gibt dir einen Link —
   **<http://localhost:4000/>** (Englisch: **<http://localhost:4000/en/>**) — und sagt dir,
   wo genau du hinschauen musst. Diese Vorschau ist **nur für dich**, noch nicht
   öffentlich. _(Funktioniert, wenn Claude Code auf deinem Rechner läuft. Wenn nicht,
   beschreibt dir der Assistent stattdessen genau, was sich geändert hat.)_
2. **Freigabe.** Der Assistent fragt dich proaktiv: _„Soll ich das jetzt
   veröffentlichen?“_ Erst wenn du **Ja** sagst, geht es online. Möchtest du vorher
   noch etwas anpassen, sag es einfach — die Vorschau wird aktualisiert und du wirst
   erneut gefragt.
3. **Live.** Nach deinem „Ja“ ist die Änderung in **ca. 1 Minute** live unter
   **<https://sschuez.github.io/thinklink/>**

Du musst nichts speichern, committen oder hochladen — du schaust dir die Vorschau an
und sagst „veröffentlichen“.

Die Website ist zweisprachig: Wenn du etwas auf der deutschen Seite änderst, wird die
englische Seite automatisch mitgepflegt (und umgekehrt).

> **Tipp:** Kleine Korrekturen kannst du ohne Vorschau direkt online stellen lassen —
> sag einfach „Veröffentliche das direkt.“

### Prüfen, ob es live ist

Öffne <https://sschuez.github.io/thinklink/> und lade die Seite neu
(am besten mit `Cmd`+`Shift`+`R`, damit nichts aus dem Cache kommt).
Wenn du nach ~1 Minute noch nichts siehst, frag einfach: „Ist die Änderung schon live?“

### Beispiele für Anfragen

- „Ändere die Bio des Präsidenten zu folgendem Text: …“
- „Füge die Konferenz 2027 zur Liste der Aktivitäten hinzu.“
- „Korrigiere den Tippfehler im Impressum: aus ‚Zürch‘ soll ‚Zürich‘ werden.“
- „Lege eine neue Seite ‚Mitgliedschaft‘ an (Deutsch und Englisch).“
- „Tausche das Teamfoto gegen die Datei, die ich gerade hochgeladen habe.“

### Bitte vorher fragen / nicht einfach bestellen

Diese Dinge ändern den **Datenschutz-Charakter** der Seite (aktuell **kein**
Cookie-Banner nötig). Bitte sprich sie an, statt sie direkt zu verlangen:

- Google Analytics oder ein anderes Statistik-/Tracking-Tool einbauen
- Ein YouTube-/Vimeo-Video oder eine Google-Maps-Karte einbetten
- Social-Media-Buttons, externe Schriftarten oder andere fremde Inhalte einbinden

Der Assistent wird hier nachfragen und erklären, was nötig wäre (z. B. die
Datenschutzerklärung anpassen oder doch ein Cookie-Banner ergänzen).

---

## English

### How to make a change

1. Open **Claude Code** in this project folder (`thinklink`) — in the terminal,
   the Claude desktop app, or at [claude.ai/code](https://claude.ai/code).
2. Write, in plain English (or German), what you want changed.
3. The assistant edits the file(s) and checks the site still builds.

### Preview, then publish

Nothing goes public until you've seen it and approved it. Before showing you the
preview, the assistant automatically checks that the site builds and that every link
and image works — if something's broken, it's fixed first. If a colleague changed
something in the meantime, the assistant pulls their latest version first, so your
edits don't overwrite each other. The flow:

1. **Preview.** The assistant starts a local preview and gives you a link —
   **<http://localhost:4000/>** (English: **<http://localhost:4000/en/>**) — and tells you
   exactly where to look. This preview is **for your eyes only**, not yet public.
   _(Works when Claude Code is running on your machine. If it isn't, the assistant
   describes precisely what changed instead.)_
2. **Approve.** The assistant proactively asks: _"Shall I publish this now?"_ Nothing
   goes online until you say **yes**. Want a tweak first? Just say so — the preview
   updates and you're asked again.
3. **Live.** After your "yes," the change is live in **about 1 minute** at
   **<https://sschuez.github.io/thinklink/>**

You never save, commit, or upload anything — you look at the preview and say "publish."

The site is bilingual: change something on the German page and the English page is
kept in sync automatically (and vice versa).

> **Tip:** For small fixes you can skip the preview — just say "Publish this directly."

### Checking it's live

Open <https://sschuez.github.io/thinklink/> and reload
(use `Cmd`+`Shift`+`R` to bypass the cache).
If nothing has changed after ~1 minute, just ask: "Is the change live yet?"

### Example requests

- "Change the president's bio to the following text: …"
- "Add the 2027 conference to the activities list."
- "Fix the typo in the imprint: 'Zürch' should be 'Zürich'."
- "Create a new page called 'Membership' (German and English)."
- "Replace the team photo with the file I just uploaded."

### Please ask first — don't just request

These change the site's **privacy posture** (it currently needs **no** cookie
banner). Raise them rather than requesting them outright:

- Adding Google Analytics or any other stats/tracking tool
- Embedding a YouTube/Vimeo video or a Google Maps map
- Adding social-media buttons, externally hosted fonts, or other third-party content

The assistant will pause and explain what would be required (e.g. updating the
privacy page, or having to add a cookie banner after all).

---

_Technical details (build, deploy, structure) live in `README.md`. Guidance for the
assistant lives in `CLAUDE.md`._
