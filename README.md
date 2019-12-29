# 3η Εργασία Αρχιτεκτονικής Υπολογιστών (Ομάδα 2)

_Ραφαήλ Μπουλογεώργος, ΑΕΜ: 9186_

_Παύλος Φραγκιαδουλάκης, ΑΕΜ: 8389_

## Βήμα 1ο - Εξοικοίωση με τον εξομοιωτή McPAT

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

## Ερώτημα 1ο

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

Η **Δυναμική Κατανάλωση** ισχύος είναι η μέση ενέργεια ανά μονάδα χρόνου που χρειάζεται κατά την αλλαγή της κατάστασης του ο αντιστροφέας και οφείλεται στην ύπαρξη ροής ρεύματος διαμέσου του διακόπτη για την φόρτιση και την εκφόρτιση του χωρητικού φορτίου αλλά και εξαιτίας των ρευμάτων βραχυκύκλωσης που δημιουργούνται στο εσωτερικό των τρανζίστορ του διακόπτη. Αυτά τα ρεύματα αναγκάζουν τους διακόπτες να καταναλώνουν ενέργεια που η οποία ανά μονάδα χρόνου ονομάζεται Δυναμική κατανάλωση Ισχύος. Αυτή η ισχύς αυξάνεται με την αύξηση της συχνότητας του ρολογιού, την τάση τροφοδοσίας και της χωρητικότητας του τρανζίστορ σύμφωνα με την εξίσωση ** P=f · C· V<sup>2</sup>** ανά κύκλο. Η νέες τεχνολογίες μικραίνουν την τάση τροφοδοσίας, αλλά οι απαιτήσεις για μεγάλη συχνότητα μπορούν να αυξήσουν την ισχύ αυτή σημαντικά.

- Πηγές
  - *Sedra, A.S. & Smith, K.C. (1982) Microelectronic Circuits, Seven Edition, p.1149*
  - *[McPAT Research](https://www.hpl.hp.com/research/mcpat/micro09.pdf)*
  - *[Semiconductor Engineering](https://semiengineering.com/knowledge_centers/low-power/low-power-design/power-consumption/)*
