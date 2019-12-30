# 3η Εργασία Αρχιτεκτονικής Υπολογιστών (Ομάδα 2)

_Ραφαήλ Μπουλογεώργος, ΑΕΜ: 9186_

_Παύλος Φραγκιαδουλάκης, ΑΕΜ: 8389_

## Βήμα 1ο - Εξοικείωση με τον εξομοιωτή McPAT

Το McPAT αποτελεί έναν εξομοιωτή ισχύος, χώρου, και χρονισμού συμβατό με πολυνηματικές και πολυπύρηνες αρχιτεκτονικές. Περιλαμβάνει τα μοντέλα επεξεργαστών, το δίκτυο επικοινωνίας, την κοινόχρηστη κρυφή μνήμη Cache και τους ελεγκτές μνήμης για να μπορέσει να εξάγει συμπεράσματα για τον χρονισμό, την έκταση του επεξεργαστή, την απαιτούμενη ισχύ για διάφορες τεχνολογίες από 90 nm μέχρι 20 nm ([HP - McPAT](https://www.hpl.hp.com/research/mcpat/)).

Για την εγκατάσταση του McPAT ακολουθήθηκαν τα παρακάτω βήματα με βάση την διατύπωση της εργασίας:
1. Δημιουργήθηκε κλώνος του McPAT repository:

```bash
git clone https://github.com/kingmouf/cmcpat.git my_mcpat
```
2. Προστίθενται οι απαραίτητοι μεταγλωττιστές εφόσον δεν υπάρχουν:

```bash
#32-bit
sudo apt install libc6-dev-i386
#64-bit
sudo apt install g++-multilib
sudo apt install gcc-7-multilib g++-7-multilib
```
3. Μεταγλώτισση με make
```bash
cd my_mcpat/mcpat
make
```

### Ερώτημα 1ο

Για την διερεύνηση των αποτελεσμάτων εξόδου, εκτελέστηκε το McPAT για τον επεξεργαστή *Xeon*, η περιγραφή του οποίου βρίσκεται στον υποφάκελο *ProcessorDescriptionFiles* για το μέγιστο επίπεδο ανάλυσης (*print_level = 5*):
```bash
./mcpat -infile ProcessorDescriptionFiles/Xeon.xml -print_level 5
```
Παρακάτω συνοψίζονται τα αποτελέσματα της προσομοίωσης με τον McPAT για τον Xeon επεξεργαστή ([Xeon - McPAT results](/src/McPAT_output/Xeon.txt))

- Τεχνολογία Τρανζίστορ : [65 nm](/src/McPAT/Xeon.txt#L6)

**Κατανάλωση Ισχύος Επεξεργαστή**
- Peak Power            : [134.938 W](/src/McPAT_output/Xeon.txt#L14)
- Total Leakage         : [36.8319 W](/src/McPAT_output/Xeon.txt#L15)
  - Subthreshold Leakage  : [35.1632 W](/src/McPAT_output/Xeon.txt#L17)
  - Gate Leakage          : [1.66871 W](/src/McPAT_output/Xeon.txt#L19)
- Peak Dynamic          : [98.1063 W](/src/McPAT_output/Xeon.txt#L16)
  - Runtime Dynamic     : [72.9199 W](/src/McPAT_output/Xeon.txt#L20)

**Dynamic Power και Leakage Power**

Η Κατανάλωση Ισχύος σε ένα ολοκληρωμένο κύκλωμα χωρίζεται σε 2 κατηγορίες: την στατική κατανάλωση ισχύος (Static Power dissipation ή Power Leakage) και την δυναμική κατανάλωση ισχύος (Dynamic power dissipation). Την ενέργεια αυτή την καταναλώνει κάθε διακόπτης για να αλλάξει (dynamic) ή για να διατηρήσει (static) την κατάσταση που βρίσκεται (on ή off).

Η **Στατική κατανάλωση ισχύος** ή **Leakage Power** αναφέρεται στην μέση ισχύ που απαιτεί ένας διακόπτης/τρανζίστορ για να βρίσκεται σε λειτουργία. Θεωρητικά εντοπίζεται ροή ρεύματος μόνο μεταξύ της πηγής και του εκπομπού του τρανζίστορ, όμως στην πράξη, υπάρχουν μικρά ρεύματα από την πύλη (Gate leakage) και από το υπόστρωμα (Subthreshold leakage) που καταναλώνουν ενέργεια *ανάλογη της τάσης τροφοδοσίας, της τάσης κατωφλίου και του λόγου W/L* δηλαδή των μεγεθών του τρανζίστορ. Η ενέργεια αυτή καταναλώνεται ακόμα και στην αλλαγή της κατάστασης του διακόπτη και για αυτό ονομάζεται Στατική.  

Η **Δυναμική Κατανάλωση** ισχύος είναι η μέση ενέργεια ανά μονάδα χρόνου που χρειάζεται κατά την αλλαγή της κατάστασης του ο αντιστροφέας και οφείλεται στην ύπαρξη ροής ρεύματος διαμέσου του διακόπτη για την φόρτιση και την εκφόρτιση του χωρητικού φορτίου αλλά και εξαιτίας των ρευμάτων βραχυκύκλωσης που δημιουργούνται στο εσωτερικό των τρανζίστορ του διακόπτη. Αυτά τα ρεύματα αναγκάζουν τους διακόπτες να καταναλώνουν ενέργεια που η οποία ανά μονάδα χρόνου ονομάζεται Δυναμική κατανάλωση Ισχύος. Αυτή η ισχύς αυξάνεται με την αύξηση της συχνότητας του ρολογιού, την τάση τροφοδοσίας και της χωρητικότητας του τρανζίστορ σύμφωνα με την εξίσωση *P=f · C· V<sup>2</sup>* ανά κύκλο. Οι νέες τεχνολογίες μικραίνουν την τάση τροφοδοσίας, αλλά οι απαιτήσεις για μεγάλη συχνότητα μπορούν να αυξήσουν την ισχύ αυτή σημαντικά.

Πηγές:
- *Sedra, A.S. & Smith, K.C. (1982) Microelectronic Circuits, Seven Edition, p.1149*
- *[McPAT Research](https://www.hpl.hp.com/research/mcpat/micro09.pdf)*
- *[Semiconductor Engineering](https://semiengineering.com/knowledge_centers/low-power/low-power-design/power-consumption/)*

Επειδή η ισχύς είναι εκφρασμένη σε ενέργεια ανά μονάδα χρόνου, δεν έχει σημασία η χρονική διάρκεια εκτέλεσης του προγράμματος.

### Ερώτημα 2ο (Energy Efficiency)
**Ενεργειακή Απόδοση** είναι η διεκπεραιωτική ικανότητα μιας αρχιτεκτονικής ανά μονάδα ισχύος δηλαδή Performance per Watt [1]. Ο λόγος αυτός είναι το μέτρο σύγκρισης συστημάτων με διαφορετική υπολογιστική ισχύ και κατανάλωση. Μπορούμε να θεωρήσουμε για ένα σύστημα τον όρο διεκπεραιωτική ικανότητα ώς τον λόγο των εντολών που εκτελεί προς τον χρόνο:

**Energy_efficiency = (Instructions/seconds)/(Power [Watt]) = Instructions/(Energy [J])**

Πηγές:
- *[1] Patterson, D A. & Hennessy, J L. (1998) Computer Organization and Design, Fifth Edition, p.49*
- [Wikipedia - Performance per watt](https://en.wikipedia.org/wiki/Performance_per_watt)

Επομένως, σε ένα εξεταζόμενο πρόγραμμα/σύστημα δεν επαρκεί η γνώση της ισχύος για κάθε επεξεργαστή· χρειάζεται ο αριθμός των εντολών που εκτελεί ο επεξεργαστής προς στην συνολική ενέργεια που καταναλώνει ή εναλλακτικά ο ρυθμός εκτέλεσης των εντολών προς την ισχύ.

Στο εξεταζόμενο υποερώτημα, δίνεται ότι οι ισχείς κατανάλωσης σε δύο επεξεργαστές είναι ίσες με *P<sub>1</sub> = 5 W* και *P<sub>2</sub> = 40 Watt* αντίστοιχα. Για να έχουμε καλύτερη ενεργειακή απόδοση (*η*) στον δεύτερο επεξεργαστή θα πρέπει να ισχύει:

*η<sub>2</sub> > η<sub>1</sub>* ή 

*(Instructions/t<sub>2</sub>)/P<sub>2</sub> > (Instructions/t<sub>1</sub>)/P<sub>1</sub>* ή 

*t<sub>1</sub>/t<sub>2</sub> > P<sub>2</sub>/P<sub>1</sub>* ή 

*t<sub>1</sub>/t<sub>2</sub> > 8*

Άρα αρκεί ο δεύτερος επεξεργαστής να είναι πάνω από 8 φορές πιο γρήγορος από τον πρώτο (προκειμένου να έχει καλύτερη ενεργειακή απόδοση ο δεύτερος από τον πρώτο).

Τα αποτελέσματα του McPAT περιέχουν στοιχεία για την συχνότητα λειτουργίας, την τεχνολογία των τρανζίστορ της συνολικής αρχιτεκτονικής και επιπλέον την κατανάλωση ισχύος, και την επιφάνεια που καταλαμβάνουν τα επιμέρους στοιχεία του συστήματος. Έτσι μπορούμε να βγάλουμε συμπεράσματα για την ισχύ που απαιτεί η συγκεκριμένη αρχιτεκτονική, χωρίς όμως να έχουμε πληροφορίες σχετικά με τον χρόνο προσομοίωσης και τις εντολές που εκτέλεσε στο διάστημα αυτό. Δεν είμαστε έτσι σε θέση να βγάλουμε συμπεράσματα για την ενεργειακή απόδοση της αρχιτεκτονικής που προσομοιώνει το McPAT.

### Ερώτημα 3ο (Σύγκριση Xeon/ARM A9)

Για την σύγκριση με τον ARM X9 εκτελούμε αντίστοιχα για το αντίστοιχο infile αρχείο:

```bash
./mcpat -infile ProcessorDescriptionFiles/ARM_A9_2GHz.xml -print_level 5
```
Τα συγκριτικά αποτελέσματα για τους δύο επεξεργαστές συνοψίζονται στον παρακάτω πίνακα:

Κατανάλωση Ισχύος Επεξεργαστή | Xeon | ARM A9 (2 GHz)
------------------------------|------|-------
Total leakage | [36.8319 W](/src/McPAT_output/Xeon.txt#L15) | [0.108687 W](/src/McPAT_output/Arm_A9_2Ghz.txt#L15)
Runtime Dynamic  | [72.9199 W](/src/McPAT_output/Xeon.txt#L20) | [2.96053 W](/src/McPAT_output/Arm_A9_2Ghz.txt#L20)

Μπορούμε να μελετήσουμε την απόδοση αυτή σε 2 κατηγορίες ανάλογα με την κατανάλωση  Dynamic Power και Leakage Power:
Αναφερόμενοι στο **Dynamic Power** ο Xeon απαιτεί περίπου 25 φορές περισσότερη ισχύ Runtime Dynamic Power, δηλαδή καταναλώνει 25 φορές περισσότερο κατά την διάρκεια που εκτελείται η εφαρμογή, σε σχέση με τον ARM. Αφού ο Xeon έχει 40 φορές μεγαλύτερη υπολογιστική ισχύ, η ενεργειακή απόδοση του Xeon κατά την εκτέλεση του προγράμματος είναι *(40 / 72.92) x 36.83 = 20* φορές καλύτερη σε σχέση με τον ARM Α9.  Θεωρούμε ότι στην διάρκεια εκτέλεσης του προγράμματος η στατική κατανάλωση είναι μικρή και δεν την λαμβάνουμε υπόψιν.

Το σύστημα δεν τερματίζει μετά το πέρας του προγράμματος, άρα για να βγάλουμε συμπεράσματα για την ενεργειακή απόδοση χρειάζεται να λάβουμε υπόψιν και το Leakage Power. Αυτή η ισχύς απαιτείται σε όλη την διάρκεια λειτουργία του συστήματος έτσι για τον Xeon είναι περίπου *36.83 W / 0.11 W = 360* φορές μεγαλύτερη από τον ARM A9. Έτσι βλέπουμε ότι ο Xeon καταναλώνει πολύ περισσότερη ενέργεια για τον ίδιο χρόνο λειτουργίας σε σχέση με τον ARM Α9. Επομένως, παρότι ο Xeon έχει καλύτερο Energy Efficiency κατά την εκτέλεση του προγράμματος δεν μπορεί να είναι πιο αποδοτικός από τον ARM Α9 για ένα σύστημα που δεν τερματίζει μετά την λήξη της εφαρμογής.

## Βήμα 2ο - gem5 + McPAT

Για πρακτικούς λόγους δίνουμε δικαιώματα εκτέλεσης στο Python script το οποίο θα μετατρέψει το αρχείο stats του gem5 σε μορφή συμβατή με το McPAT:

```bash
chmod +x ./my_mcpat/Scripts/GEM5ToMcPAT.py
```

```bash
./Scripts/GEM5toMcPAT.py <gem5 stats file> <gem5 config file (json)> ./mcpat/ProcessorDescriptionFiles/inorder_arm.xml -o Gem5ToMcPat.xml
```

Από την δεύτερη εργασία χρησιμοποιούμε τα αποτελέσματα του [Gem5](/src/Gem5_output/Benchmarks_results/) και με την παραπάνω εντολή δημιουργούμε αρχεία xml για την εκτέλεσή του στον McPat. Για λόγους ευκολίας και ταχύτητας δημιουργήθηκε το παρακάτω bash script:

[GEM5ToMcPAT.sh](/src/Gem5ToMcPAT/GEM5ToMcPAT.sh)

Το script αυτό παίρνει ως πρώτο όρισμα το φάκελο όπου βρίσκονται τα αποτελέσματα του Gem5. Έχει την δυνατότητα να διαβάσει όλους τους υποφακέλους και να δημιουργήσει σε έναν νέο φάκελο, που προαιρετικά μπαίνει ως δεύτερο όρισμα, τα αντίστοιχα αρχεία xml. Είναι αναγκαίο να βρίσκεται στον φάκελο *my_mcpat* δηλαδή στο (cloned) repository που φτιάξαμε για το McPAT. 
*Το script μπορεί να δεχτεί και ένα 3ο όρισμα που αφορά το όνομα του φακέλου που θα εκτυπωθούν τα αποτελέσματα από τον προσομοιωτή McPAT με είσοδο τα xml που δημιουργήθηκαν προηγουμένως. Εάν δεν δοθεί το όρισμα αυτό δεν εκτελείται η προσομοίωση.*

Τα βήματα που ακολουθήθηκαν είναι τα εξής:
- Δημιουργούμε όλα τα xml στο φάκελο *src/McPAT_output/Benchmarks_results_xml/<benchmark_name>_McPAT/<Benchmark_name>.xml*
- Τρέχουμε για όλα τα xml το McPAT και αποθηκεύουμε τα αποτελέσματα σε αντίστοιχους υποφακέλους:  *./src/McPAT_output/Benchmarks_results_McPAT/<benchmark_name>_McPAT/<Benchmark_name>.txt*
- Το script εκτελείται με την παρακάτω εντολή, ενώ όλα τα errors αποθηκεύονται στο *./GEM5ToMcPAT_errors* :
 
 ```[DIR: ./GEM5ToMcPat.sh ./src/Gem5_output/Benchmarks_results/<Benchmark_name>  ./src/McPAT_output/Benchmarks_results_xml/<Benchmark_name> ./src/McPAT_output/Benchmarks_results_McPAT/<Benchmark_name>]
 ```

### Ερώτημα 1ο

Για να βγάλουμε αποτελέσματα για το EDAP ( Energy – Delay – Area ) χρειαζόμαστε τα στατιστικά και των 2 προσομοιώσεων:
-	**Energy** : Θα πάρουμε τα αποτελέσματα από την έξοδο του McPAT και όπως αναφέρει η εκφώνηση αφορά τα μεγέθη Runtime Dynamic, Subthreshold Leakage και Gate Leakage. Αυτά τα νούμερα αναφέρονται στην μέση ισχύ. Παρόλα αυτά, χρησιμοποιώντας το Delay όπως ορίζεται παρακάτω μπορούμε να βρούμε και τη συνολική μέση ενέργεια που κατανάλωσε το σύστημα για το συγκεκριμένο Benchmark.
-	**Delay**: Την παράμετρο αυτή θα την βρούμε στο stats του Gem5 και εξάγεται από την τιμή *sim_seconds*.
-	**Area**: Θα την βρούμε στην έξοδο του McPAT στα αντίστοιχα πεδία *Area*.
- Για την τιμή του **Energy Efficiency** θα λάβουμε υπόψιν τον λόγο 1/[sim_seconds*(Runtime Dynamic + Total Leakage]) για κάθε προσομοίωση που έγινε με το ίδιο Benchmark. Αυτό το κάνουμε γιατί όλες οι αρχιτεκτονικές εκτέλεσαν τον ίδιο κώδικα (άρα παραλείπουμε το Instructions στον αριθμητή). Έτσι μπορούμε να συγκρίνουμε πιο είναι ενεργειακά αποδοτικότερο για τη συγκεκριμένη εφαρμογή κάθε φορά.

### Ερώτημα 2ο

Τα αποτελέσματα βρίσκονται στο φάκελο ./src/Energy_results με τα αντίστοιχα ονόματα από κάθε Benchmarks.

Για την εύρεση της επίπτωσης στην απόδοση στις διάφορες παραμέτρους που εξετάζουμε, τα παρακάτω εύρη που αναφέρονται παρακάτω. Να σημειωθεί ότι το μέγεθος των Data/Instruction για την L1 είναι επιλεγμένο έτσι ώστε να το άθροισμά τους να μην υπερβαίνει τα 256 kB:
  * Cacheline Size: 32, **64**, 128
  * L1 Data Size [kB]: 16, **32**, 64, 128
  * L1 Instruction Size [kB]: 16, 32, **64**, 128
  * L1 Data Associativity: **1**, 2, 4
  * L1 Instruction Associativity: **1**, 2, 4
  * L2 Data Associativity: 1, **2**, 4
  * L2 Size [kB]: **512**, 1024, 2048, 4096  
  
Στα παραπάνω, με έντονη γραμματοσειρά σημειώνονται οι default τιμές. 
Ο αριθμός των instructions που εκτελέστηκε είναι ίσος με 10<sup>8</sup>, γεγονός που επηρέασε τη μη σημαντική επίπτωση των μεταβολών του L1 instruction size, το οποίο θα ήταν αναμενόμενο. 

Παρακάτω παρατίθενται τα χαρακτηριστικά γραφήματα για τις παραπάνω περιπτώσεις, στις οποίες παρουσιάζεται κάποια αξιοσημείωτη μεταβολή στις παραμέτρους εξόδου: Area/Power/Energy Efficiency. Το Power παρακάτω αναπαρίσταται ως Total (Total Leakage + Runtime Dynamic) και vw Peak, προκειμένου να υπάρχει μία αίσθηση της διαφοράς της επίπτωσης στις μέσες και στις ακραίες τιμές της ισχύος. Το Energy Efficiency, όπως αναφέρεται παραπάνω είναι εκφρασμένο ανά μονάδα Instructions, ώστε να απλοποιείται η σύγκριση μεταξύ των σεναρίων. Ειδικά στο spechmmer, υπάρχει ένας επιπλέον πολ/σμός με έναν παράγοντα 0.0005, για την διευκόλυνση της απεικόνισης στο ίδιο γράφημα.

#### CACHE LINE
Το μέγεθος του Cache Line φαίνεται να επηρεάζει σχεδόν όλα τα μεγέθη ενδιαφέροντος.
* Cache Line effect to Power
![Cache Line effect to Power](charts/01_CACHE_W.png)

Παρατηρούμε ότι υπάρχει σημαντική αύξηση του Peak Power με την αύξηση του block size και όχι τόσο στο Total Power.

* Cache Line effect to Area
![Cache Line effect to Area](charts/01_CACHE_AREA.png)

Η επίπτωση του block size στο Area είναι σημαντική κυρίως στη μετάβαση από 64 kB στα 128 kB.

* Cache Line effect to Energy Efficiency
![Cache Line effect to Efficiency](charts/01_CACHE_PERF.png)

Στα spechmmer και speclibm βλέπουμε μία μικρή αύξηση στο ανηγμένο efficiency, ενώ στα specbzip, specmcf, specsjeng έχουμε μείωση του efficiency καθώς αυξάνεται το block size.

#### L1D size/L1I size

* L1D size/L1I size effect to Power
![L1D size/L1I size effect to Power](charts/02_L1D_L1I_W.png)

Η επίπτωση του L1 Instruction Size, καθώς και του L1 Data Size δεν είναι σημαντική για τα μεγέθη 16 kB/32 kB, ενώ έπειτα το Power αυξάνει σημαντικά στα 64 kB/128 kB και στις δύο περιπτώσεις (L1 Instruction και L1 Data Size). Τα συμπεράσματα είναι κοινά για όλα τα benchmarks.

* L1D size/L1I size effect to Area
![L1D size/L1I size effect to Area](charts/02_L1D_L1I_AREA.png)

Η επίπτωση του L1 Instruction Size, καθώς και του L1 Data Size δεν είναι σημαντική για τα μεγέθη 16 kB/32 kB, ενώ έπειτα το Area αυξάνει σημαντικά στα 64 kB/128 kB και στις δύο περιπτώσεις (L1 Instruction και L1 Data Size). Τα συμπεράσματα είναι κοινά για όλα τα benchmarks.

* L1D size/L1I size effect to Efficiency
![L1D size/L1I size effect to Efficiency](charts/02_L1D_L1I_PERF.png)

Βλέπουμε ότι σε όλες τις περιπτώσεις του L1 Data Size/L2 Data Size το ανηγμένο efficiency είναι μεγαλύτερο στα 16 kB/32 kB (όπου οι τιμές είναι περίπου ίδιες).

#### L1D associativity

* L1D associativity effect to Power
![L1D associativity effect to Power](charts/03_L1D_ASSOC_W.png)

To Power (Peak) φαίνεται να αυξάνεται λίγο περισσότερο κυρίως στη μετάβαση από 2 σε 4 σε όλα τα benchmarks.

* L1D associativity effect to Area
![L1D associativity effect to Area](charts/03_L1D_ASSOC_AREA.png)

To Area φαίνεται να αυξάνεται σημαντικά κυρίως στη μετάβαση από 2 σε 4 σε όλα τα benchmarks.

* L1D associativity effect to Efficiency
![L1D associativity effect to Efficiency](charts/03_L1D_ASSOC_PERF.png)

To efficiency φαίνεται να είναι υψηλότερο στις περιπτώσεις όπου το associativity παίρνει τις τιμές 1 και 2 (για όλα τα benchmarks).

#### L1I associativity

* L1I associativity effect to Power
![L1I associativity effect to Power](charts/04_L1I_ASSOC_W.png)

To Power (Peak) φαίνεται να πέφτει λίγο περισσότερο κυρίως στη μετάβαση από 2 σε 4 σε όλα τα benchmarks.

* L1I associativity effect to Area
![L1I associativity effect to Area](charts/04_L1I_ASSOC_AREA.png)

To Area φαίνεται να πέφτει κατά τη μετάβαση από 2 σε 4 σε όλα τα benchmarks.

* L1I associativity effect to Efficiency
![L1I associativity effect to Efficiency](charts/04_L1I_ASSOC_PERF.png)

To efficiency φαίνεται να είναι υψηλότερο στις περιπτώσεις όπου το associativity παίρνει την τιμή 4 (για όλα τα benchmarks).

#### L2D associativity

* L2D associativity effect to Power
![L2D associativity effect to Power](charts/05_L2D_ASSOC_W.png)

To Power (Peak+Total) φαίνεται να μην επηρεάζεται σημαντικά σε όλα τα benchmarks.

* L2D associativity effect to Area
![L2D associativity effect to Area](charts/05_L2D_ASSOC_AREA.png)

To Area φαίνεται να μην επηρεάζεται σημαντικά σε όλα τα benchmarks.

* L2D associativity effect to Efficiency
![L2D associativity effect to Efficiency](charts/05_L2D_ASSOC_PERF.png)

To efficiency δεν φαίνεται να επηρεάζεται από το L2D associativity (για όλα τα benchmarks).

#### L2 size [kB]

* L2 size effect to Power
![L2 size effect to Power](charts/06_L2_SIZE_W.png)

To Power (Peak) φαίνεται να αυξάνεται ελαφρώς με την αύξηση του L2 size.

* L2 size effect to Area
![L2 size effect to Area](charts/06_L2_SIZE_AREA.png)

To Area φαίνεται να αυξάνεται σημαντικά για L2 size &ge; 1 MB.

* L2 size effect to Efficiency
![L2 size effect to Efficiency](charts/06_L2_SIZE_PERF.png)

To efficiency δεν φαίνεται να επηρεάζεται συνολικά λόγω μεταβολής του L2 size (για όλα τα benchmarks).

