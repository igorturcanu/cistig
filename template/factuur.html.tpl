<!doctype html>
<html lang="nl">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex">
  <title>Factuur – {{name}}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,500;1,500&family=Source+Sans+3:wght@400;600&display=swap">
  <style>
    :root{--navy:#14304f;--gold:#b08d3c;--ink:#1c2430;--muted:#556070;--rule:#d9dee6;--tint:#f3f5f8;
      --serif:"EB Garamond",Georgia,serif;--sans:"Source Sans 3",system-ui,sans-serif;color-scheme:light}
    *{box-sizing:border-box}
    body{margin:0;background:var(--tint);color:var(--ink);font:16px/1.5 var(--sans)}
    .tools{max-width:860px;margin:0 auto;padding:16px max(16px,env(safe-area-inset-left,0px));display:flex;flex-wrap:wrap;gap:10px;align-items:center}
    .tools p{margin:0;color:var(--muted);flex:1 1 280px;font-size:.95rem}
    button,.btn{font:inherit;border:1px solid var(--navy);background:var(--navy);color:#fff;padding:10px 20px;cursor:pointer;text-decoration:none;display:inline-block}
    button.alt,.btn.alt{background:#fff;color:var(--navy)}
    button:hover,.btn:hover{background:var(--gold);border-color:var(--gold);color:var(--navy)}
    :focus-visible{outline:2px solid var(--gold);outline-offset:2px}
    .sheet{max-width:860px;margin:0 auto 24px;background:#fff;padding:40px max(24px,env(safe-area-inset-left,0px));border-top:4px solid var(--navy)}
    h1,h2{font-family:var(--serif);font-weight:500;color:var(--navy);margin:0}
    h1{font-size:2.2rem;line-height:1.1}
    h1 em{color:var(--gold)}
    h2{font-size:1.15rem;margin-bottom:6px}
    .head{display:flex;justify-content:space-between;gap:24px;flex-wrap:wrap;padding-bottom:20px;border-bottom:1px solid var(--rule)}
    .head .role{color:var(--muted);margin:4px 0 0}
    .title{font-family:var(--serif);font-size:2rem;color:var(--navy);text-align:right}
    label{display:block;font-size:.78rem;letter-spacing:.12em;text-transform:uppercase;color:var(--muted);margin:10px 0 2px}
    input,select,textarea{font:inherit;color:var(--ink);width:100%;padding:7px 9px;border:1px solid var(--rule);background:#fff;border-radius:0}
    textarea{resize:vertical}
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:0 32px;margin-top:20px}
    .grid>div{min-width:0}
    .three{display:grid;grid-template-columns:repeat(3,1fr);gap:0 16px}
    table{width:100%;border-collapse:collapse;margin-top:28px}
    th{font-size:.78rem;letter-spacing:.12em;text-transform:uppercase;color:var(--muted);text-align:left;font-weight:600;padding:6px 6px;border-bottom:2px solid var(--navy)}
    td{padding:6px;border-bottom:1px solid var(--rule);vertical-align:top}
    th.n,td.n{text-align:right}
    td.n input{text-align:right}
    td.amount{white-space:nowrap;text-align:right;padding-top:13px}
    td.x{width:36px;padding-left:0}
    td.x button{background:none;border:0;color:var(--muted);padding:6px 8px;font-size:1.1rem}
    td.x button:hover{background:none;color:#a33}
    .table-wrap{overflow-x:auto}
    .totals{margin:16px 0 0 auto;width:min(340px,100%)}
    .totals div{display:flex;justify-content:space-between;gap:12px;padding:5px 0}
    .totals .sum{border-top:2px solid var(--navy);margin-top:6px;padding-top:10px;font-weight:600;font-size:1.2rem;color:var(--navy)}
    .pay{margin-top:28px;padding:16px 20px;background:var(--tint);border-left:3px solid var(--gold)}
    .pay p{margin:0}
    .foot{margin-top:24px;color:var(--muted);font-size:.9rem}
    .mail{max-width:860px;margin:0 auto 40px;padding:0 max(16px,env(safe-area-inset-left,0px))}
    .mail textarea{min-height:200px}
    .mail .row{display:flex;gap:10px;flex-wrap:wrap;margin-top:10px}
    .note{color:var(--muted);font-size:.9rem}
    @media (max-width:640px){
      .grid,.three{grid-template-columns:1fr}
      .title{text-align:left}
      .sheet{padding-top:28px;padding-bottom:28px}
    }
    @media print{
      @page{size:A4;margin:16mm}
      body{background:#fff}
      .tools,.mail,.noprint,td.x,th.x{display:none!important}
      .sheet{margin:0;padding:0;border-top:0;max-width:none}
      input,select,textarea{border:0;padding:0;appearance:none;-webkit-appearance:none;background:none;resize:none}
      .table-wrap{overflow:visible}
    }
  </style>
</head>
<body>
  <div class="tools noprint">
    <p>Vul de gegevens in, kies <strong>Opslaan als PDF</strong> en stuur de PDF mee met de e-mail hieronder. Uw eigen gegevens (adres, BTW-nummer, IBAN) worden alleen in deze browser onthouden.</p>
    <button type="button" id="print">Opslaan als PDF</button>
  </div>

  <main class="sheet" id="sheet">
    <div class="head">
      <div>
        <h1>{{name_html}}</h1>
        <p class="role">{{role_cap}} · {{languages}}</p>
        <p class="role">{{email}} · {{phone}}</p>
      </div>
      <div class="title">Factuur</div>
    </div>

    <div class="grid">
      <div>
        <h2>Van</h2>
        <label for="adres">Adres</label>
        <textarea id="adres" rows="3" data-setting placeholder="Straat en huisnummer&#10;Postcode en plaats"></textarea>
        <div class="three">
          <div><label for="kvk">KvK-nummer</label><input id="kvk" data-setting value="{{kvk_value}}" inputmode="numeric"></div>
          <div><label for="btwnr">BTW-nummer</label><input id="btwnr" data-setting placeholder="NL000000000B01"></div>
          <div><label for="rtv">Rtv-nummer</label><input id="rtv" data-setting value="{{rtv_value}}"></div>
        </div>
        <div class="three" style="grid-template-columns:2fr 1fr">
          <div><label for="iban">IBAN</label><input id="iban" data-setting placeholder="NL00 BANK 0000 0000 00"></div>
          <div><label for="bank">Bank</label><input id="bank" data-setting placeholder="Naam van de bank"></div>
        </div>
      </div>
      <div>
        <h2>Aan</h2>
        <label for="klant">Naam klant of bedrijf</label>
        <input id="klant" placeholder="Bijvoorbeeld: Advocatenkantoor De Vries">
        <label for="klantadres">Adres</label>
        <textarea id="klantadres" rows="3" placeholder="Straat en huisnummer&#10;Postcode en plaats"></textarea>
        <label for="kenmerk">Kenmerk of zaaknummer (niet verplicht)</label>
        <input id="kenmerk">
      </div>
    </div>

    <div class="grid" style="margin-top:8px">
      <div class="three">
        <div><label for="nr">Factuurnummer</label><input id="nr"></div>
        <div><label for="datum">Factuurdatum</label><input id="datum" type="date"></div>
        <div><label for="termijn">Betaaltermijn (dagen)</label><input id="termijn" type="number" min="0" value="14"></div>
      </div>
      <div>
        <label for="vervalt">Uiterste betaaldatum</label>
        <input id="vervalt" readonly>
      </div>
    </div>

    <div class="table-wrap">
      <table>
        <thead><tr><th>Omschrijving</th><th class="n" style="width:90px">Aantal</th><th class="n" style="width:120px">Tarief (€)</th><th class="n" style="width:120px">Bedrag</th><th class="x"></th></tr></thead>
        <tbody id="rows"></tbody>
      </table>
    </div>
    <p class="noprint"><button type="button" class="alt" id="add">+ Regel toevoegen</button></p>

    <div class="totals">
      <div><span>Subtotaal</span><span id="sub">€ 0,00</span></div>
      <div><span>BTW <select id="btw" style="width:auto;display:inline-block;padding:2px 6px"><option value="21">21%</option><option value="9">9%</option><option value="0">0%</option></select></span><span id="btwbedrag">€ 0,00</span></div>
      <div class="sum"><span>Totaal</span><span id="tot">€ 0,00</span></div>
    </div>

    <div class="pay">
      <p id="paytext"></p>
    </div>
    <p class="foot" id="foot"></p>
  </main>

  <section class="mail noprint">
    <h2>E-mail aan de klant</h2>
    <p class="note">Deze tekst past zich aan op de factuur. Kopieer hem, plak hem in uw e-mail en voeg de PDF als bijlage toe.</p>
    <label for="mailtext">E-mailtekst</label>
    <textarea id="mailtext" readonly></textarea>
    <div class="row">
      <button type="button" id="copy">Kopieer de tekst</button>
      <a class="btn alt" id="mailto" href="#">Open in e-mailprogramma</a>
    </div>
    <p class="note" id="copied" role="status"></p>
  </section>

  <script>
  (function () {
    var $ = function (id) { return document.getElementById(id); };
    var NAME = {{name_js}};
    var PHONE = {{phone_js}};
    var KEY = 'factuur-instellingen-' + location.pathname;
    var euro = new Intl.NumberFormat('nl-NL', { style: 'currency', currency: 'EUR' });

    function load() { try { return JSON.parse(localStorage.getItem(KEY) || '{}'); } catch (e) { return {}; } }
    function save(o) { try { localStorage.setItem(KEY, JSON.stringify(o)); } catch (e) {} }

    var settings = load();
    document.querySelectorAll('[data-setting]').forEach(function (el) {
      if (settings[el.id]) el.value = settings[el.id];
      el.addEventListener('input', function () { settings[el.id] = el.value; save(settings); update(); });
    });

    function addRow(desc, qty, rate) {
      var tr = document.createElement('tr');
      tr.innerHTML = '<td><textarea rows="2" class="d" placeholder="Omschrijving"></textarea></td>' +
        '<td class="n"><input class="q" type="number" min="0" step="0.25"></td>' +
        '<td class="n"><input class="r" type="number" min="0" step="0.01"></td>' +
        '<td class="amount"></td>' +
        '<td class="x"><button type="button" class="alt" aria-label="Regel verwijderen" title="Verwijderen">×</button></td>';
      tr.querySelector('.d').value = desc || '';
      tr.querySelector('.q').value = qty == null ? '' : qty;
      tr.querySelector('.r').value = rate == null ? '' : rate;
      tr.querySelectorAll('input,textarea').forEach(function (e) { e.addEventListener('input', update); });
      tr.querySelector('button').addEventListener('click', function () { tr.remove(); update(); });
      $('rows').appendChild(tr);
    }

    function longDate(d) { return d.toLocaleDateString('nl-NL', { day: 'numeric', month: 'long', year: 'numeric' }); }

    function update() {
      var sub = 0;
      document.querySelectorAll('#rows tr').forEach(function (tr) {
        var line = (parseFloat(tr.querySelector('.q').value) || 0) * (parseFloat(tr.querySelector('.r').value) || 0);
        tr.querySelector('.amount').textContent = euro.format(line);
        sub += line;
      });
      var pct = parseFloat($('btw').value) || 0;
      var btw = Math.round(sub * pct) / 100;
      var tot = sub + btw;
      $('sub').textContent = euro.format(sub);
      $('btwbedrag').textContent = euro.format(btw);
      $('tot').textContent = euro.format(tot);

      var d = $('datum').value ? new Date($('datum').value + 'T12:00:00') : new Date();
      var due = new Date(d); due.setDate(due.getDate() + (parseInt($('termijn').value, 10) || 0));
      $('vervalt').value = longDate(due);

      var nr = $('nr').value || '…';
      var iban = $('iban').value || '[IBAN]';
      var pay = 'Gelieve het totaalbedrag van ' + euro.format(tot) + ' uiterlijk op ' + longDate(due) +
        ' over te maken op IBAN ' + iban + ' t.n.v. ' + NAME + ', onder vermelding van factuurnummer ' + nr + '.';
      $('paytext').textContent = pay;

      var parts = [];
      if ($('kvk').value) parts.push('KvK ' + $('kvk').value);
      if ($('btwnr').value) parts.push('BTW ' + $('btwnr').value);
      if ($('rtv').value) parts.push('Rtv ' + $('rtv').value);
      if ($('bank').value) parts.push($('bank').value);
      $('foot').textContent = parts.join(' · ');

      var klant = $('klant').value.trim();
      var mail = (klant ? 'Beste ' + klant : 'Geachte heer/mevrouw') + ',\n\n' +
        'Hierbij ontvangt u mijn factuur ' + nr + ' van ' + longDate(d) + ' voor een bedrag van ' + euro.format(tot) + '. ' +
        'Gelieve dit bedrag uiterlijk op ' + longDate(due) + ' over te maken op IBAN ' + iban + ' t.n.v. ' + NAME +
        ', onder vermelding van het factuurnummer.\n\n' +
        'De factuur zit als PDF in de bijlage. Heeft u een vraag, neem dan gerust contact met mij op.\n\n' +
        'Met vriendelijke groet,\n' + NAME + '\n' + PHONE;
      $('mailtext').value = mail;
      $('mailto').href = 'mailto:?subject=' + encodeURIComponent('Factuur ' + nr + ' – ' + NAME) + '&body=' + encodeURIComponent(mail);
    }

    var today = new Date();
    $('datum').value = today.toISOString().slice(0, 10);
    $('nr').value = today.getFullYear() + '-001';
    addRow('Voorbeeld: tolken tijdens een zitting (3 uur)', 3, 60);
    addRow('Voorbeeld: reiskosten', 1, 12.5);
    ['klant', 'klantadres', 'kenmerk', 'nr', 'datum', 'termijn', 'btw'].forEach(function (id) { $(id).addEventListener('input', update); });
    $('add').addEventListener('click', function () { addRow('', '', ''); });
    $('print').addEventListener('click', function () { window.print(); });
    $('copy').addEventListener('click', function () {
      var t = $('mailtext');
      var done = function () { $('copied').textContent = 'De tekst is gekopieerd.'; };
      var fallback = function () { t.select(); try { document.execCommand('copy'); done(); } catch (e) { $('copied').textContent = 'Selecteer de tekst en kopieer hem handmatig.'; } };
      if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(t.value).then(done, fallback); else fallback();
    });
    update();
  })();
  </script>
</body>
</html>
