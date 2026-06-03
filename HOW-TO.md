# Änderungen an der Website machen / Editing the website

This page is for **non-coders**. You do not need to understand HTML, Git or Jekyll.
You describe the change in plain words, and the assistant makes it, checks it, and
publishes it. Diese Seite ist für **Nicht-Techniker:innen** gedacht.

---

## Deutsch

### So machst du eine Änderung

1. Öffne **Claude Code** in diesem Projektordner (`thinklink`) — entweder im Terminal,
   in der Claude-Desktop-App oder auf [claude.ai/code](https://claude.ai/code).
2. Schreib in normalem Deutsch (oder Englisch), was du geändert haben möchtest.
3. Fertig. Der Assistent ändert die Datei(en), prüft, dass die Website noch baut,
   und veröffentlicht die Änderung.

Du musst **nichts** speichern, committen oder hochladen — das passiert automatisch.

### Was danach passiert

- Die Änderung ist nach **ca. 1 Minute** live unter
  **https://sschuez.github.io/thinklink/**
- Die Website ist zweisprachig. Wenn du etwas auf der deutschen Seite änderst,
  wird die englische Seite automatisch mitgepflegt (und umgekehrt).

### Prüfen, ob es live ist

Öffne https://sschuez.github.io/thinklink/ und lade die Seite neu
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
3. That's it. The assistant edits the file(s), checks the site still builds,
   and publishes the change.

You never have to save, commit, or upload anything — that happens automatically.

### What happens next

- The change is live in **about 1 minute** at
  **https://sschuez.github.io/thinklink/**
- The site is bilingual. Change something on the German page and the English page
  is kept in sync automatically (and vice versa).

### Checking it's live

Open https://sschuez.github.io/thinklink/ and reload
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

*Technical details (build, deploy, structure) live in `README.md`. Guidance for the
assistant lives in `CLAUDE.md`.*
