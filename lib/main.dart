import 'package:flutter/material.dart';
import 'dart:async';
import 'character.dart';
import 'delve_event.dart';
import 'dart:math';

var _sedClr =  Color.fromARGB(255, 0, 143, 24);
var lightScheme = ColorScheme.fromSeed(seedColor:_sedClr, brightness: Brightness.light);
var darkScheme = ColorScheme.fromSeed(seedColor: _sedClr, brightness: Brightness.dark);
ThemeMode _themeMode = ThemeMode.system;
bool isDark = false;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forager\'s Delve',
      theme: ThemeData(colorScheme: lightScheme, textTheme: TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.bold,),
        titleLarge: TextStyle(fontWeight: FontWeight.bold, ),
        )),
      darkTheme: ThemeData(colorScheme: darkScheme, textTheme: TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.bold,),
        titleLarge: TextStyle(fontWeight: FontWeight.bold, ),
        )),
      themeMode: _themeMode,
      home: const MyHomePage(title: 'Forager\'s Delve'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  int _seconds = 0;

  List eventPrintColors = <Color> [];

  /*Player Character*/
  PlayerCharacter playerCharacter = PlayerCharacter("Ronan Blaidd", "Fighter", "Wolf", "assets/images/WolfFighter.png");
  
  List playerCharacterNames = ["Ronan Blaidd", "Etta Hilsby"];


  /*Event Lists*/
  List delveCombatEvents = [
    /*String nam, int xp, int gol, int lvl, int type */
  ComEvent(MonsterCharacter("crumbling skeleton", 5, 10, 3, 0)),
  ComEvent(MonsterCharacter("limping zombie", 5, 8, 3, 1)),
  ComEvent(MonsterCharacter("small slime", 5, 8, 3, 2)),
  ComEvent(MonsterCharacter("mischevious imp", 6, 12, 3, 3)),
  ComEvent(MonsterCharacter("skeleton", 20, 32, 5, 0)),
  ComEvent(MonsterCharacter("zombie",20, 20, 5, 1)),
  ComEvent(MonsterCharacter("medium slime", 20, 16, 5, 2)),
  ComEvent(MonsterCharacter("vicious imp", 24, 20, 5, 3)),
  ];
  List delveCombatEvents2 = [
    /*String nam, int xp, int gol, int lvl, int type */
  ComEvent(MonsterCharacter("skeleton warrior", 50, 25, 8, 0)),
  ComEvent(MonsterCharacter("chunky zombie", 50, 25, 8, 1)),
  ComEvent(MonsterCharacter("large slime", 50, 30, 8, 2)),
  ComEvent(MonsterCharacter("hellhound", 60, 40, 8, 3)),
  ];
  List delveTrapEvents = [
    /*int st, double dmg, int dc, String hurtString, String missString */
    TrapEvent(6, (5), 10, " breathes in poisonous spores from the mushrooms lining the nearby walls!", 
    " is able to stop from breathing in the poisonous spores from the mushrooms lining the nearby walls."),
    TrapEvent(7, (5), 10, " is struck by a flying arrow from a slit in the wall!", 
    " narrowly avoids a flying arrow from a trap!"),
    TrapEvent(8, (5), 10, " takes a lashing of psychic energy from a mysterious purple orb!", 
    " avoids staring at a mysterious purple orb."),
  ];

  List delveTreasureEvents = [
    /*int gold, String treasureString*/
    TreasureEvent(5, " finds some gold coins!"),
    TreasureEvent(1, " finds just a piece of gold."),
    TreasureEvent(10, " finds just enough silver coins to equal ten pieces of gold!"),
    TreasureEvent(3, " finds a large pile of copper coins...equal to 3 gold."),
    TreasureEvent(25, " finds a rough garnet!"),
    TreasureEvent(40, " finds a finely-cut garnet!"),
  ];

  List delveFillerEvents = [
    /*String message*/
    FillerEvent(" eats a weird bug and doesn't even care."), 
    FillerEvent("  contemplates past events."),
    FillerEvent(" wanders aimlessly for a moment before finding the way forward."),
    FillerEvent(" wonders what lies deep down in this dungeon."), 
    FillerEvent(" sees a skeleton, but it isn't moving."),
    FillerEvent(" wonders what is for dinner."),
    
  ];

  List currentSpells = <Spell>[];

  int healthPotion = 0, magicPotion = 0, potionPrice = 5,
  weaponUpgradePrice = 100, armorUpgradePrice = 100;

  List eventLog = <String> ["An adventurer stand at the precipe of the dungeon, ready to advance into its depths."];
  int events = 1;

  @override

  void initState() {
    super.initState();

    int en = Random().nextInt(playerCharacterNames.length);
    setInitialPlayerCharacterStats(playerCharacterNames[en]);
    eventPrintColors.add(Colors.green);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeEffect();
    });
  }

  void setInitialPlayerCharacterStats (String name) {
    playerCharacter.name = name;
    if (playerCharacter.name == "Ronan Blaidd") {
      playerCharacter.attributes[0].val = 8;
      playerCharacter.attributes[1].val = 6;
      playerCharacter.attributes[2].val = 7;
      playerCharacter.attributes[3].val = 6;
      playerCharacter.attributes[4].val = 5;
      playerCharacter.attributes[5].val = 5;
      playerCharacter.attributes[6].val = 6;
      playerCharacter.attributes[7].val = 4;
      playerCharacter.baseWeaponDie = 10;
      playerCharacter.spells.add(Spell("Healing", "A basic healing spell.", 5, 3, "healing"));
      playerCharacter.setPronouns("He","His","Him");
      playerCharacter.setPortrait("assets/images/WolfFighter.png");
      playerCharacter.setSpecies("Wolf");
      playerCharacter.setJob("Fighter");
      playerCharacter.hpMod = 15;
      playerCharacter.traits.add(Trait("Healing Wind", "Naturally heals faster.", 5, 2, 0));
      playerCharacter.level = 1;
    } else if (playerCharacter.name == "Etta Hilsby") {
      playerCharacter.attributes[0].val = 3;
      playerCharacter.attributes[1].val = 5;
      playerCharacter.attributes[2].val = 5;
      playerCharacter.attributes[3].val = 5;
      playerCharacter.attributes[4].val = 10;
      playerCharacter.attributes[5].val = 10;
      playerCharacter.attributes[6].val = 4;
      playerCharacter.attributes[7].val = 6;
      playerCharacter.baseWeaponDie = 16;
      playerCharacter.spells.add(Spell("Healing", "A basic healing spell.", 5, 3, "healing"));
      playerCharacter.spells.add(Spell("Insight", "Gather knowledge through magic.", 10, 0, "xpGain"));
      playerCharacter.setPronouns("She","Her","Her");
      playerCharacter.setPortrait("assets/images/MoleWizard.png");
      playerCharacter.setSpecies("Mole");
      playerCharacter.setJob("Wizard");
      playerCharacter.traits.add(Trait("Winds of Magic", "Naturally gains magic back faster.", 5, 2, 1));
      playerCharacter.level = 1;
    }
    else {

    }
    playerCharacter.setBaseStats();
    playerCharacter.fillHP();
    playerCharacter.fillMP();
    playerCharacter.applyTraits();
    setPrices();
  }

  void changeMode() {
    setState(() {
      if (!isDark) {
      _themeMode = ThemeMode.dark;
      isDark = true;
    } else {
      _themeMode = ThemeMode.light;
      isDark = false;
    }
    });
  }

  void _delve() {
    if (playerCharacter.currentHP > 0) {
      setState(() {
      int delveRand = Random().nextInt(_seconds + 100) % 100;
      if ((delveRand < 10) && (delveRand > 0)) {
        eventPrintColors.add(Colors.amber);
        int en = Random().nextInt(delveRand*_seconds + delveTreasureEvents.length) % delveTreasureEvents.length;
        eventLog.add(delveTreasureEvents[en].findTreasure(playerCharacter));
        playerCharacter.xp++;
        events++;
      }
      else if ((delveRand < 33) && (delveRand >= 10)) {
        /*Encounter*/
        eventPrintColors.add(Colors.purpleAccent);
        if (playerCharacter.level > 2) {
          int r = Random().nextInt(2);
          if (r == 0) {
            int en = Random().nextInt(_seconds +delveCombatEvents2.length) % delveCombatEvents2.length;
            eventLog.add(delveCombatEvents2[en].fight(playerCharacter));
          } else {
            int en = Random().nextInt(_seconds +delveCombatEvents.length) % delveCombatEvents.length;
            eventLog.add(delveCombatEvents[en].fight(playerCharacter));
          }
        } else {
          int en = Random().nextInt(_seconds +delveCombatEvents.length) % delveCombatEvents.length;
          eventLog.add(delveCombatEvents[en].fight(playerCharacter));
        }  
        events++;
      }
      else if ((delveRand < 50) && (delveRand >= 33)) {
        /*Trap*/
        eventPrintColors.add(Colors.red);
        int en = Random().nextInt(delveRand*_seconds + delveTrapEvents.length) % delveTrapEvents.length;
        eventLog.add(delveTrapEvents[en].trap(playerCharacter));
        events++;
      }
      else if ((delveRand < 63) && (delveRand >= 50)) {
        /*Encounter*/
        eventPrintColors.add(Colors.purpleAccent);
        int en = Random().nextInt(_seconds +delveCombatEvents.length) % delveCombatEvents.length;
        eventLog.add(delveCombatEvents[en].fight(playerCharacter));
        events++;
      }
      else if ((delveRand < 72) && (delveRand >= 63)) {
        /*Trap*/
        eventPrintColors.add(Colors.red);
        int en = Random().nextInt(delveRand*_seconds + delveTrapEvents.length) % delveTrapEvents.length;
        eventLog.add(delveTrapEvents[en].trap(playerCharacter));
        events++;
      }
       else {
        /*Filler*/
        eventPrintColors.add(Colors.white);
        int en = Random().nextInt(delveRand*_seconds + delveFillerEvents.length) % delveFillerEvents.length;
        eventLog.add(delveFillerEvents[en].happen(playerCharacter));
        events++;
      }
    });
    }
  }

  void castSpell(int index) {
    if (playerCharacter.currentMP >= playerCharacter.spells[index].spellCost) {
      num x = (playerCharacter.spells[index].spellPower + playerCharacter.stats[5]);
      if (playerCharacter.spells[index].effect == "healing") {
        healing(x);
      } else if (playerCharacter.spells[index].effect == "xpGain") {
        playerCharacter.xp += x.toInt();
      } else if (playerCharacter.spells[index].effect == "goldGain") {
        playerCharacter.gold += x.toInt();
      }
      playerCharacter.currentMP -= playerCharacter.spells[index].spellCost;
    }  
    }

  void healing (num spellPower) {
    if (playerCharacter.currentMP > 0) {
      setState(() {
        if (playerCharacter.currentHP < playerCharacter.stats[0]) {
          playerCharacter.modHP(spellPower.toDouble());
        } else {
          playerCharacter.fillHP();
        }
        
      });
    }
  }

  void timeEffect () {
      setState(() {   _seconds++;  playerCharacter.recover();});
  }

  void increaseGold(int y) {
    setState(() { playerCharacter.gold += y; });
  }

  void setPrices() { 
    setState(() {
      potionPrice = applyDiscount(potionPrice);
      armorUpgradePrice = applyDiscount(armorUpgradePrice);
      weaponUpgradePrice = applyDiscount(weaponUpgradePrice);
    });
  }

  int applyDiscount(int d) {
    if (d > (d - ((d*playerCharacter.stats[10])/100).toInt())) {
      return d - ((d*playerCharacter.stats[10])/100).toInt();
    } else {
      return d;
    }
  }

  void useHealthPotion() {
    setState(() {   
      if (healthPotion > 0) {
        playerCharacter.modHP(10);
        healthPotion--;
      }
      });
  }

  void useMagicPotion() {
    setState(() {   
      if (magicPotion > 0) {
        playerCharacter.modMP(5);
        magicPotion--;
      }
      });
  }

  void purchaseHealthPotion() {
    setState(() {   
      if (playerCharacter.gold >= potionPrice) {
        playerCharacter.gold -= potionPrice; healthPotion++;
      }
      });
  }

  void purchaseMagicPotion() {
    setState(() { if (playerCharacter.gold >= potionPrice) {
        playerCharacter.gold -= potionPrice; magicPotion++;
      }});
  }
  

  void upgradeArmor() {
    setState(() {   
      if (playerCharacter.gold >= armorUpgradePrice) {
        playerCharacter.gold -= armorUpgradePrice; playerCharacter.armorLevel++;
        armorUpgradePrice = 100 * playerCharacter.armorLevel;
        setPrices();
        playerCharacter.setBaseStats();
      }
      });
  }

  void upgradeWeapon() {
    setState(() { if (playerCharacter.gold >= weaponUpgradePrice) {
        playerCharacter.gold -= weaponUpgradePrice; playerCharacter.weaponLevel++;
        weaponUpgradePrice = 100 * playerCharacter.weaponLevel;
        setPrices();
        playerCharacter.setBaseStats();
      }});
  }


  @override
  
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            IconButton(onPressed: changeMode, icon: isDark ? Icon(Icons.nights_stay):Icon(Icons.sunny)),
            Text("STATS",style: Theme.of(context).textTheme.titleSmall),
            Text("HP: ${playerCharacter.currentHP.toStringAsFixed(1)}/${playerCharacter.stats[0]} (${playerCharacter.healRate.toStringAsFixed(3)} per second)",),
            Text("MP: ${playerCharacter.currentMP.toStringAsFixed(1)}/${playerCharacter.stats[1]} (${playerCharacter.magicRate.toStringAsFixed(3)} per second)"),
            Text("Attack: ${playerCharacter.stats[2]}"),
            Text("Defense: ${playerCharacter.stats[3]}"),
            Text("Damage Bonus: ${playerCharacter.stats[4]}"),
            Text("Cast Bonus: ${playerCharacter.stats[5]}"),
            Text("Critical %: ${playerCharacter.stats[9]}"),
            Text("Discount: ${playerCharacter.stats[10]}"),
            Text("Saving Throws", style: Theme.of(context).textTheme.titleSmall,),
            Text("Fortitude: ${playerCharacter.stats[6]}"),
            Text("Reflex: ${playerCharacter.stats[7]}"),
            Text("Willpower: ${playerCharacter.stats[8]}"),
            Text("Equipment", style: Theme.of(context).textTheme.titleSmall,),
            Text("Weapon Die: d${playerCharacter.baseWeaponDie}"),
            Text("Damage Threshold: ${playerCharacter.armorLevel}"),
          ],
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amber, width: 8),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ Theme.of(context).cardColor,
              Theme.of(context).secondaryHeaderColor, Theme.of(context).primaryColor,
            ], 
            )
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 50,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                Text("CHARACTER", style: TextStyle(fontSize: 25),),
                Text("Name: ${playerCharacter.name}"),
                Text("Job: ${playerCharacter.job}"),
                Text("Species: ${playerCharacter.species}"),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3)
                  ),
                  child: Image.asset(playerCharacter.portraitID, width: MediaQuery.of(context).size.height/6,height:  MediaQuery.of(context).size.height/6)),
                  Row(
                    children: [
                      Text("Level: ${playerCharacter.level} XP: ${playerCharacter.xp}/${playerCharacter.xpNeeded}"),
                      ElevatedButton(onPressed: playerCharacter.levelUp, child: Text("Level up")),
                    ],
                  ),
                  Text("Attributes", style: TextStyle(fontSize: 15),),
                  SizedBox(width: 250,height: MediaQuery.of(context).size.height/5, child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Text("${playerCharacter.attributes[index].name}: ${playerCharacter.attributes[index].val}");
                      }),
                    ),
                    Text("Traits", style: TextStyle(fontSize: 25)),
                SizedBox(
                  width: 300,height:  MediaQuery.of(context).size.height/8,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: playerCharacter.traits.length,
                      itemBuilder: (context, index) {
                        return Card(
                        child: 
                        ListTile(
                        title: Text( "${playerCharacter.traits[index].name}", style: Theme.of(context).textTheme.titleSmall),
                        subtitle: Text( "${playerCharacter.traits[index].description}")
                    ),
                  );
                }),
              )
                  
              ],
            ),
            Column(
              spacing: 3,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("ADVENTURE", style: TextStyle(fontSize: 25)),
                ElevatedButton(onPressed: _delve, child: Text("DELVE!")),
                Text("LOG"),
                  Divider(),
                  SizedBox( width: 400, height:  MediaQuery.of(context).size.height/2,
                  
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: eventLog.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: BoxBorder.all(color: eventPrintColors[index])
                          ),
                          child: Text("${eventLog[index]}", style: TextStyle(color: eventPrintColors[index]),)
                        );
                      }),
                    )
                  
                  
                  
                ]
            ),
            Column(
              spacing: 3,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("STATUS", style: TextStyle(fontSize: 25)),
                Text("HP: ${playerCharacter.currentHP.toInt()}/${playerCharacter.stats[0]}"),
                Text("MP: ${playerCharacter.currentMP.toInt()}/${playerCharacter.stats[1]}"),
                Text("Time passed (in seconds): $_seconds"),
                Text("Gold: ${playerCharacter.gold}"),
                Text("INVENTORY", style: TextStyle(fontSize: 25)),
                Row(
                  children: [
                    Text("Weapon Level: ${playerCharacter.weaponLevel}"),  ElevatedButton(onPressed: upgradeWeapon, child: Text("Upgrade: $weaponUpgradePrice"))
                  ],
                ),
                Row(
                  children: [
                    Text("Armor Level: ${playerCharacter.armorLevel}"),  ElevatedButton(onPressed: upgradeArmor, child: Text("Upgrade: $armorUpgradePrice"))
                  ],
                ),
                Row(
                  children: [
                    Text("Health Potions: $healthPotion"),  ElevatedButton(onPressed: useHealthPotion, child: Text("Use")), ElevatedButton(onPressed: purchaseHealthPotion, child: Text("Buy: $potionPrice"))
                  ],
                ),
                Row(
                  children: [
                    Text("Magic Potions: $magicPotion"), ElevatedButton(onPressed: useMagicPotion, child: Text("Use")), ElevatedButton(onPressed: purchaseMagicPotion, child: Text("Buy: $potionPrice"))
                  ],
                ),
                Text("SPELLS", style: TextStyle(fontSize: 25)),
                SizedBox(
                  width: MediaQuery.of(context).size.width/5,height: MediaQuery.of(context).size.height/5,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: playerCharacter.spells.length,
                      itemBuilder: (context, index) {
                        return Card(
                        child: ListTile(
                        title: Text( "${playerCharacter.spells[index].spellName} (MP: ${playerCharacter.spells[index].spellCost})", style: Theme.of(context).textTheme.titleSmall,),
                       trailing: IconButton(icon: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                        onPressed: () => castSpell(index),
                      ),
                    ),
                  );
                }),
              ),
              
              ],
            )
          ],
        ),
        ),
      ),
    );
  }
}
