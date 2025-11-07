import 'package:flutter/material.dart';
import 'dart:async';
import 'character.dart';
import 'delve_event.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 0, 143))
      ),
      home: const MyHomePage(title: 'A Flutterful Adventure'),
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
  PlayerCharacter playerCharacter = PlayerCharacter("Ronan Blaidd", "Fighter", "Wolf", "assets/images/WolfFighter.png");
  List delveCombatEvents = [
  ComEvent(MonsterCharacter("crumbling skeleton",5,5, 3, 0)),ComEvent(MonsterCharacter("limping zombie",5,5, 3, 1)),
  ComEvent(MonsterCharacter("small slime",5,5, 3, 2)),ComEvent(MonsterCharacter("imp",6,6, 3, 3)),
  ComEvent(MonsterCharacter("skeleton",5,8, 5, 0)),ComEvent(MonsterCharacter("zombie",3,8, 5, 1)),
  ];

  List currentSpells = <Spell>[];


  int healthPotion = 0, magicPotion = 0, potionPrice = 5,
  weaponUpgradePrice = 100, armorUpgradePrice = 100;
  

  

  List eventLog = <String> ["You stand at the precipe of the dungeon, ready to advance into its depths."];
  int events = 1;
  

  @override

  void initState() {
    super.initState();

    setInitialPlayerCharacterStats();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeEffect();
    });
  }

  void setInitialPlayerCharacterStats () {
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
    } else {

    }
    playerCharacter.setBaseStats();
    playerCharacter.fillHP();
    playerCharacter.fillMP();
    setPrices();
  }

  void _delve() {
    if (playerCharacter.currentHP > 0) {
      setState(() {
      int delveRand = Random().nextInt(_seconds) % 8;
      if (delveRand == 0) {
        playerCharacter.gold += 5;
        eventLog.add("You find a small pile of gold!");
        events++;
      } else if (delveRand == 1) {
        num st = Random().nextInt(20);
        st += playerCharacter.stats[7];
        if (st > 10) {
          eventLog.add("You narrowly avoid a flying arrow from a trap!");
        } else {
          eventLog.add("A flying arrow from a trap strikes you!");
          playerCharacter.modHP((-Random().nextInt(4) - 1)/playerCharacter.armorLevel);
        }
        playerCharacter.xp++;
        events++;
      }
      else if (delveRand == 2) {
        /*Encounter*/
        int en = Random().nextInt(_seconds) % delveCombatEvents.length;
        eventLog.add(delveCombatEvents[en].fight(playerCharacter));
      }
      else if (delveRand == 3) {
        num st = Random().nextInt(20);
        st += playerCharacter.stats[6];
        if (st > 10) {
          eventLog.add("You are able to hold your breath as you walk through a room full of poisonous gas!");
        } else {
          eventLog.add("You fail to hold your breath as you walk through a room of poisonous gas!");
          playerCharacter.modHP(-Random().nextInt(4) - 1);
        }
        playerCharacter.xp++;
        events++;
      }
      else if (delveRand == 4) {
        /*??*/
        eventLog.add("${playerCharacter.name} wanders aimlessly through the dungeons.");
        events++;
      }
      else if (delveRand == 5) {
        /*??*/
        eventLog.add("${playerCharacter.name} contemplates past events.");
        events++;
      }
      else if (delveRand == 6) {
        /*??*/
        eventLog.add("${playerCharacter.name} eats a weird bug and doesn't even care.");
        events++;
      }
      else if (delveRand == 7) {
        /*Encounter*/
        int en = Random().nextInt(delveRand*_seconds) % delveCombatEvents.length;
        eventLog.add(delveCombatEvents[en].fight(playerCharacter));
      }
    });
    }
  }

  void castSpell(int index) {
    if (playerCharacter.currentMP >= playerCharacter.spells[index].spellCost) {
      if (playerCharacter.spells[index].effect == "healing") {
        healing(playerCharacter.spells[index].spellPower);
      }
      playerCharacter.currentMP -= playerCharacter.spells[index].spellCost;
    }  
    }

  void healing (num spellPower) {
    if (playerCharacter.currentMP > 0) {
      setState(() {
        if (playerCharacter.currentHP < playerCharacter.stats[0]) {
          playerCharacter.modHP((playerCharacter.stats[5] * 2)/2 + spellPower);
        } else {
          playerCharacter.fillHP();
        }
        
      });
    }
  }

  void timeEffect () {
      setState(() {   _seconds++;    });
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
        playerCharacter.modHP(5);
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
      }
      });
  }

  void upgradeWeapon() {
    setState(() { if (playerCharacter.gold >= weaponUpgradePrice) {
        playerCharacter.gold -= weaponUpgradePrice; playerCharacter.weaponLevel++;
        weaponUpgradePrice = 100 * playerCharacter.weaponLevel;
        setPrices();
      }});
  }


  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
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
                  child: Image.asset(playerCharacter.portraitID)),
                  Row(
                    children: [
                      Text("Level: ${playerCharacter.level} XP: ${playerCharacter.xp}/${playerCharacter.xpNeeded}"),
                      ElevatedButton(onPressed: playerCharacter.levelUp, child: Text("Level up")),
                    ],
                  ),
                  Text("Attributes", style: TextStyle(fontSize: 15),),
                  SizedBox(width: 250,height: 170, child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Text("${playerCharacter.attributes[index].name}: ${playerCharacter.attributes[index].val}");
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
                  SizedBox( width: 400, height: 300,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: eventLog.length,
                      itemBuilder: (context, index) {
                        return Text("$index. ${eventLog[index]}");
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
                Text("${playerCharacter.stats}"),
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
                  width: 250,height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: playerCharacter.spells.length,
                      itemBuilder: (context, index) {
                        return Card(
                        child: ListTile(
                        title: Text( "${playerCharacter.spells[index].spellName} (MP: ${playerCharacter.spells[index].spellCost})", style: Theme.of(context).textTheme.bodyLarge,),
                       trailing: IconButton(icon: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                        onPressed: () => castSpell(index),
                      ),
                    ),
                  );
                }),
              )
              
              ],
            )
          ],
        ),
      ),
    );
  }
}
