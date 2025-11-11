import "dart:developer";

import "character.dart";

 class ComEvent {
  int rounds = 0;

  MonsterCharacter monster = MonsterCharacter("", 1, 1, 1, 0);
  
  ComEvent(MonsterCharacter mon) {
    monster = mon;
  }

  String fight(PlayerCharacter pc){
    monster.monsterInit();
    while ((pc.currentHP > 0) && (monster.currentHP > 0)) {
      if (pc.hitsAttack(monster.stats[2])) {
        monster.takeDamage(pc.weaponDamage());
      }
      if (monster.currentHP > 0) {
        monster.autoAttack(pc);
      }
      log("Player: ${pc.currentHP} Monster ${monster.currentHP}");
    }
    monster.fillHP();
    if (pc.currentHP <= 0) {
      pc.gold = (pc.gold/2).toInt();
      return "${pc.name} loses a fight against a ${monster.name} and is forced to crawl back!";
    } else {
      pc.gold += monster.goldGain; pc.xp += monster.xpGain;
      return "${pc.name} wins a fight against a ${monster.name} and reaps the rewards!";
    }
  }
}

class TreasureEvent {
  int goldReward = 5;
  String treasureString = " finds some gold!";

  TreasureEvent(int gol, String trstr) {
    goldReward = gol;
    treasureString = trstr;
  }

  String findTreasure(PlayerCharacter pc) {
    pc.gold += goldReward;
    return pc.name + treasureString;
  }
}

class TrapEvent {
  int savingThrowNum = 6, difficulty = 10;
  double trapDamage = 5;
  String trapHurt = " gets hurt.";
  
  String trapMiss = " avoids the trap";

  TrapEvent(int st, double dmg, int dc, String str1, String str2) {
    savingThrowNum = st;
    trapDamage = dmg;
    difficulty = dc;
    trapHurt = str1;
    trapMiss = str2;
  }

  String trap(PlayerCharacter pc) {
    bool pass = pc.makeSavingThrow(savingThrowNum, difficulty);

    if (pass) {
          return pc.name + trapMiss;
        } else {
          pc.modHP(-trapDamage);
          return pc.name + trapHurt;
        }
  }
}

class FillerEvent {
  String message = " wanders the halls.";

  FillerEvent(String str) {
    message = str;
  }

  String happen(PlayerCharacter pc) {
    String full = "${pc.name} $message";
    return full;
  }
}