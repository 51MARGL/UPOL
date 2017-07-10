using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cv_7 {

    public class Student {
        public string OsCislo { get; set; }
        public string Jmeno { get; set; }
        public string Prijmeni { get; set; }
        public string UserName { get; set; }
        public int Rocnik { get; set; }
        public string OborKomb { get; set; }

        public override string ToString () {
            return $"{OsCislo}, {Jmeno}, {Prijmeni}, {UserName}, {Rocnik}, {OborKomb}";
        }
    }

    public class ReadonlyDB {
        public static Student[] Students = {
   new Student() {
      OsCislo="R140347",
      Jmeno="Zdeněk",
      Prijmeni="BARTAL",
      UserName="bartzd03",
      Rocnik=3,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R15878",
      Jmeno="Rostislav",
      Prijmeni="CIBULKA",
        UserName="ciburo00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15880",
      Jmeno="Ema",
      Prijmeni="CSÁKÁNYIOVÁ",
        UserName="csakem00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15881",
      Jmeno="Matyáš",
      Prijmeni="ČERNOHOUS",
        UserName="cernma21",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15885",
      Jmeno="Aleš",
      Prijmeni="DOPITA",
        UserName="dopitaa",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15887",
      Jmeno="Martin",
      Prijmeni="FILIPI",
        UserName="filima05",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R14316",
      Jmeno="Daniel",
      Prijmeni="HÁJEK",
        UserName="hajeda00",
        Rocnik=3,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R14315",
      Jmeno="Daniel",
      Prijmeni="HÁJEK",
        UserName="hajeda00",
        Rocnik=3,
      OborKomb="MI"}
      ,
      new Student() {
      OsCislo="R150570",
      Jmeno="Václav",
      Prijmeni="HLAVINKA",
        UserName="hlavva00",
        Rocnik=2,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R15892",
      Jmeno="Petr",
      Prijmeni="HOLÁŇ",
        UserName="holape00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15894",
      Jmeno="Jan",
      Prijmeni="HRABAL",
        UserName="hrabja08",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15895",
      Jmeno="David",
      Prijmeni="HRŮZA",
        UserName="hruzda01",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R140554",
      Jmeno="Tomáš",
      Prijmeni="CHLUP",
        UserName="chluto00",
        Rocnik=3,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R15369",
      Jmeno="Albert",
      Prijmeni="KAUFMAN",
        UserName="kaufal00",
        Rocnik=2,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R14913",
      Jmeno="Patrik",
      Prijmeni="KRAIF",
        UserName="kraipa00",
        Rocnik=3,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15910",
      Jmeno="Serhiy",
      Prijmeni="KUDRYASHOV",
        UserName="kudrse00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15916",
      Jmeno="Libor",
      Prijmeni="MACHÁLEK",
        UserName="machli00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15350",
      Jmeno="Zdeněk",
      Prijmeni="MAZURÁK",
        UserName="mazuzd00",
        Rocnik=2,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R15922",
      Jmeno="Zbyněk",
      Prijmeni="MLČÁK",
        UserName="mlcazb00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15924",
      Jmeno="Jan",
      Prijmeni="MOLČÍK",
        UserName="molcja00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15351",
      Jmeno="Adam",
      Prijmeni="OBRTEL",
        UserName="obrtad00",
        Rocnik=2,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R15935",
      Jmeno="Libor",
      Prijmeni="POLÁŠEK",
        UserName="polali00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R14843",
      Jmeno="Tomáš",
      Prijmeni="POSPÍŠIL",
        UserName="pospto05",
        Rocnik=3,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15944",
      Jmeno="Radim",
      Prijmeni="SEKERA",
        UserName="sekera00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15357",
      Jmeno="Michaela",
      Prijmeni="SIEKELOVÁ",
        UserName="siekmi00",
        Rocnik=2,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R14856",
      Jmeno="Michal",
      Prijmeni="STARIAT",
        UserName="starmi00",
        Rocnik=3,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15949",
      Jmeno="Lukáš",
      Prijmeni="STŘELECKÝ",
        UserName="strelu00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15957",
      Jmeno="František",
      Prijmeni="TOMAN",
        UserName="tomafr00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15959",
      Jmeno="Viet",
      Prijmeni="TRAN HOANG",
        UserName="tranvi00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15361",
      Jmeno="Michal",
      Prijmeni="VÁCLAVEK",
        UserName="vaclmi04",
        Rocnik=2,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R15961",
      Jmeno="Petr",
      Prijmeni="VALIGURA",
        UserName="valipe00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15363",
      Jmeno="David",
      Prijmeni="VRBA",
        UserName="vrbada00",
        Rocnik=2,
      OborKomb="MI"}
      , new Student() {
      OsCislo="R15968",
      Jmeno="Tomáš",
      Prijmeni="ZÁLEŠÁK",
        UserName="zaleto00",
        Rocnik=2,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R14874",
      Jmeno="Michael",
      Prijmeni="ZAPLETAL",
        UserName="zaplmi06",
        Rocnik=3,
      OborKomb="APLINF"}
      , new Student() {
      OsCislo="R15971",
      Jmeno="Lenka",
      Prijmeni="ZAPLETALOVÁ",
        UserName="zaplle02",
        Rocnik=2,
      OborKomb="APLINF"}};
    }
}
