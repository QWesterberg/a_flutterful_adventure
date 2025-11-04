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
  List delveCombatEvents = [ComEvent(MonsterCharacter("Skeleton",5,20))];


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
      int delveRand = Random().nextInt(7);
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
          eventLog.add("You flying arrow from a trap strikes you!");
          playerCharacter.modHP((-Random().nextInt(4) - 1)/playerCharacter.armorLevel);
        }
        playerCharacter.xp++;
        events++;
      }
      else if (delveRand == 2) {
        /*Encounter*/
        int en = Random().nextInt(delveRand*_seconds) % delveCombatEvents.length;
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
        eventLog.add("You find a small pile of gold!");
        playerCharacter.gold++;
      }
      else if (delveRand == 5) {
        /*??*/
        eventLog.add("You find a small pile of gold!");
        playerCharacter.gold++;
      }
      else if (delveRand == 6) {
        /*??*/
        eventLog.add("You find a small pile of gold!");
        playerCharacter.gold++;
      }
    });
    }
  }

  void _castHealing () {
    if (playerCharacter.currentMP > 0) {
      playerCharacter.modHP((playerCharacter.stats[5] + 2)/2);
      playerCharacter.modMP(-5);
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
        healthPotion--;
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
      }
      });
  }

  void upgradeWeapon() {
    setState(() { if (playerCharacter.gold >= weaponUpgradePrice) {
        playerCharacter.gold -= weaponUpgradePrice; playerCharacter.weaponLevel++;
        weaponUpgradePrice = 100 * playerCharacter.weaponLevel;
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
                  Text("${playerCharacter.attributes[0].name}: ${playerCharacter.attributes[0].val}"),
                  Text("${playerCharacter.attributes[1].name}: ${playerCharacter.attributes[1].val}"),
                  Text("${playerCharacter.attributes[2].name}: ${playerCharacter.attributes[2].val}"),
                  Text("${playerCharacter.attributes[3].name}: ${playerCharacter.attributes[3].val}"),
                  Text("${playerCharacter.attributes[4].name}: ${playerCharacter.attributes[4].val}"),
                  Text("${playerCharacter.attributes[5].name}: ${playerCharacter.attributes[5].val}"),
                  Text("${playerCharacter.attributes[6].name}: ${playerCharacter.attributes[6].val}"),
                  Text("${playerCharacter.attributes[7].name}: ${playerCharacter.attributes[7].val}"),
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
                  SizedBox(width: 500, height: 500,
                  child: Expanded(child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8),
                      itemCount: eventLog.length,
                      itemBuilder: (context, index) {
                        return Text("$index. ${eventLog[index]}");
                      }),
                    ))
                  
                  
                  
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
                ElevatedButton(onPressed: _castHealing, child: Text("Cast Healing (5 MP)"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
