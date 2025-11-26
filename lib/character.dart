import "dart:math";


abstract class BaseCharacter<T extends Object> {

  String name = "", job = "", species = "", portraitID = "";   

  String lp1 = "ze", lp2 = "zir", lp3 = "zem", p1 = "Ze", p2 = "Zir", p3 = "Zem";
  
  int gold = 0, level = 1, hpMod = 10, mpMod = 10, armorLevel = 1, weaponLevel = 1, baseWeaponDie = 6;

  double healRate = 0.1, magicRate = 0.1;

  /*Stats by index:
  0 - Hit Points: How much damage you can take.
  1 - Magic Points: How much you can cast spells.
  2 - Attack: Increases the accuracy of your attacks.
  3 - Defense: Decrease chance you will be hit.
  4 - Melee Damage Bonus: Bonus to damage with Melee attacks.
  5 - Casting Bonus: Bonus to casting with Magic.
  6 - Fort: Saving Throw based on physical resistance.
  7 - Reflex: Saving Throw based on reflexes and agility.
  8 - Will: Saving Throw based on mental resilience and willpower.
  9 - Crit Chance: Chance you will get a critical hit. 
  10 - Discount: Amount purchases are decreased by.
  */
  List stats = <int> [/*Max HP*/ 10, /*Max MP*/10, /*ATK*/ 0, /*DEF*/ 10, /*DMG+*/ 0, /*Cast+*/0, /*ST*/0, 0, 0, /*Crit%*/5, /*Discount */ 0];
  List attributes = <Attribute> [
    Attribute("Strength", "Sheer physical power-boosts Hit Points and Melee Damage Bonus."),
    Attribute("Agility", "Reflexes and quick movement - boosts Reflex and Defense."),
    Attribute("Dexterity", "Finesse and skill with hands - boosts Attack."),
    Attribute("Endurance", "Stamina and resilience-boosts Hit Points and Fort."),
    Attribute("Intelligence", "Knowledge and memory - boosts Magic Points and Casting Bonus."),
    Attribute("Spirit", "Force of will and connection to the spiritual realm - boosts Magic Points and Will."),
    Attribute("Charisma", "Good looks and personality - boosts Defense and Discount."),
    Attribute("Luck", "Sheer blind luck - boosts Crit Chance and Saving Throws.")
  ];

  double currentHP = 10, currentMP = 10;

  List spells = <Spell>[];

  void setName(String string) { name = string; }

  void setJob(String string) {  job = string; }

  void setPronouns (String pronoun1, String pronoun2, String pronoun3) {
    p1 = pronoun1;
    p2 = pronoun2;
    p3 = pronoun3;
    lp1 = pronoun1.toLowerCase();
    lp2 = pronoun2.toLowerCase();
    lp3 = pronoun3.toLowerCase();
  }

  void recover() {
    modHP(healRate);
    modMP(magicRate);
  }


  void setSpecies(String string) {  species = string;  }

  void setPortrait(String string) {  portraitID = string;}

  void setAttributes(List<int> nums) { 
    for (int i = 0; i<8; i++) {
      attributes[i].setVal(nums[i]);
    }
  }

  void setRandAttributes(int r, int b) {
    for (int i = 0; i<8; i++) {
      attributes[i].setRandVal(r, b);
    }
  }

  void modHP(double a) { currentHP += a;
    if (currentHP > stats[0]) {
      currentHP = (stats[0])/2 * 2;
    }
  }
  
  bool doesCrit () {
    int critRoll = Random().nextInt(100);
    if (critRoll <= stats[9]) {
      // ignore: avoid_print
      print("CRITS!");
      return true;
    }
    return false;
  }

  void fillHP() { currentHP = (stats[0])/2 * 2;}

  void modMP(double a) { currentMP += a;
    if (currentMP > stats[1]) {
      currentMP =(stats[1])/2 * 2;
    }
  }

  bool makeSavingThrow(int save, int dc) {
    num st = Random().nextInt(20);
    st += stats[save];
    if (dc > st) {
      return false;
    } else {
      return true;
    }
  }

  void fillMP() { currentMP = (stats[1])/2 * 2;}
  
  void setBaseStats () {
    for (int i = 0; i<8; i++) {
      attributes[i].updateMod();
    }
    stats[0] = attributes[0].mod + attributes[3].mod*2 + hpMod;
    stats[1] = attributes[4].mod + attributes[5].mod*2 + mpMod;
    stats[2] = attributes[2].mod;
    stats[3] = 10 + attributes[1].mod + attributes[6].mod + armorLevel;
    stats[4] = attributes[0].mod + weaponLevel;
    stats[5] = attributes[4].mod;
    stats[6] = attributes[3].mod + attributes[7].mod;
    stats[7] = attributes[1].mod + attributes[7].mod;
    stats[8] = attributes[5].mod + attributes[7].mod;
    stats[9] = attributes[7].mod + 5;
    stats[10] = attributes[6].mod;
  }
}


class Attribute {
  String name = "", description;
  int val = 5, mod = 0;

  Attribute(this.name, this.description);

  void setRandVal (int r, int b) {
    val = b + Random().nextInt(r);
    mod = val - 5;
  }

  void setVal (int a) {
    val = a;
    updateMod();
  } 

  void updateMod () {
    mod = val - 5;
  }

  void upVal (int a) {
    val++;
    updateMod();
  }
}

class PlayerCharacter extends BaseCharacter{
  int xp = 0, xpNeeded = 10;
  List traits = <Trait>[];

  PlayerCharacter(String nam, String jo, String spe, String por) {
   super.name = nam;
   super.job = jo;
   super.species = spe;
   super.portraitID = por;
  }
  
  void levelUp() {
    if (xp >= xpNeeded) {
      xp -= xpNeeded;
      level++;
      xpNeeded *= super.level + 2;
      if (job == "Fighter") {
        super.attributes[0].upVal(1);
        super.attributes[2].upVal(1);
      }
      else if (job == "Wizard") {
        super.attributes[4].upVal(1);
        super.attributes[5].upVal(1);
      }
      super.hpMod += 5;
      super.mpMod += 5;
      super.attributes[Random().nextInt(8)].upVal(1);
      super.setBaseStats();
      applyTraits();
      super.fillHP();
      super.fillMP();
      
    }
  }

  bool hitsAttack (num target) {
    num attackRoll = Random().nextInt(20) + stats[2];
    if (attackRoll >= target) {
      return true;
    } else {
      return false;
    }
  }

  num weaponDamage() {
    num damage = Random().nextInt(super.baseWeaponDie) + stats[4];
    if (super.doesCrit()) {
      return damage * 2;
    }
    return damage;
  }

  num spellDamage(int spellDamageDie) {
    return Random().nextInt(spellDamageDie) + stats[5];
  }

  void attacked (num attack, num damage) {
    if (attack > stats[3]){
      if (damage > super.armorLevel) {
        super.modHP(- (damage).toDouble());
      }
      
    }
  }

/*
TypeNum effects:
-0: Applies modifier to an attribute (0-7 on the array)
-1: Boosts a stat directly (hit points, magic points, Attack, Defense, critChance)
-2: Causes regen effect at percentile (0 for HP, 1 for MP)
-3: Percentile increase to stat (same as 1)
(Feel free to come up with more!)
*/
void applyTraits() {
  for (int i = 0; i<traits.length; i++) {
    applyTrait(traits[i]);
  }
}

void applyTrait(Trait trait) {
    if (trait.typeNum == 0) {
      super.attributes[trait.typeNum2] = attributes[trait.typeNum2] + trait.mod;
    }
    else if (trait.typeNum == 1) {
      super.stats[trait.typeNum2] = stats[trait.typeNum2] + trait.mod;
    }
    else if (trait.typeNum == 2) {
      if (trait.typeNum2 == 0) {
        healRate += (trait.mod/100);
      }
      if (trait.typeNum2 == 1) {
        magicRate += (trait.mod/100);
      }
      
    }
    else if (trait.typeNum == 3) {
      super.stats[trait.typeNum2] = stats[trait.typeNum2] + (stats[trait.typeNum2]*trait.mod)/100;
    }
  }

  

}

class Trait {
  String name = "", description;
  int mod = 0, typeNum = 0, typeNum2 = 0;
  
  Trait(this.name, this.description, this.mod, this.typeNum, this.typeNum2);
}

class MonsterCharacter extends BaseCharacter {
  int xpGain = 0, goldGain = 0, typeInt = 0;

  bool isDead = false;

  bool canCast = false;

  MonsterCharacter(String nam, int xp, int gol, int lvl, int type) {
    super.name = nam;
    xpGain = xp;
    goldGain = gol;
    super.level = lvl;
    typeInt = type;
  }
  /*
  Types: 
  -0: Boney Undead (Skeletons of all kinds): +1 Agility, Dexterity, flat 3 to Intelligence, Spirit, Luck
  -1: Fleshy Undead (Zombies of all kinds): +4 Strength and Endurance, -3 Agility and Dexterity, flat 3 to everything else
  -2: Gooey (Oozes, Jellies, slimes): +1 to Agility, Dexterity, Endurance, -1 to Intelligence, Spirit
  -3: Demonic (Demons, Imps, Hellhounds):+ 1 to everything
  Feel free to add more!
  */

  List spellSTInts = <int>[6];

  void monsterInit() {
    super.setRandAttributes(super.level, 5);
    switch(typeInt) {
      case 0:
      super.attributes[1].upVal(1); super.attributes[2].upVal(1); super.attributes[4].setVal(3); super.attributes[5].setVal(3); super.attributes[7].setVal(3);
      super.hpMod = 10;
      case 1:
      super.attributes[0].upVal(4); super.attributes[1].upVal(-3); super.attributes[2].upVal(-3); super.attributes[3].upVal(4);      
      super.attributes[4].setVal(3); super.attributes[5].setVal(3); super.attributes[6].setVal(3); super.attributes[7].setVal(3);
      super.hpMod = 15;
      case 2:
      super.attributes[1].upVal(-1); super.attributes[2].upVal(-1); super.attributes[3].upVal(1);      
      super.attributes[4].upVal(-1); super.attributes[5].upVal(-1);
      super.hpMod = 15;
      case 3:
      super.attributes[0].upVal(1); super.attributes[1].upVal(1); super.attributes[2].upVal(1); super.attributes[3].upVal(1);      
      super.attributes[4].upVal(1); super.attributes[5].upVal(1); super.attributes[6].upVal(1); super.attributes[7].upVal(1);
      super.baseWeaponDie = 8;
      super.hpMod = 11;
      super.mpMod = 11;
      canCast = true;
      spellSTInts.add(7);
      default: 
      super.setRandAttributes(super.level, 5);
    }
    hpMod *= super.level;
    mpMod *= super.level;
    super.setBaseStats();
  }

  /*
  6 - Fort: Saving Throw based on physical resistance.
  7 - Reflex: Saving Throw based on reflexes and agility.
  8 - Will: Saving Throw based on mental resilience and willpower.
  */

  void attackPlayer (PlayerCharacter pc) {
    if (super.currentMP >= 5 && canCast == true) {
      int st = spellSTInts[Random().nextInt(spellSTInts.length)];
      int d = (level + super.stats[5]).toInt();
      autoSpellAttack(pc, st, super.stats[5]*2 + 10, d);
      
    } else {
      autoAttack(pc);
    }
  }

  void autoAttack (PlayerCharacter pc) {
    pc.attacked(monsterAttack(), monsterDamage());
  }

  void autoSpellAttack (PlayerCharacter pc, int st, int dc, int dmg) {
    double x = (Random().nextInt(dmg) + super.stats[5] + 10)/(2);
    if (pc.makeSavingThrow(st, dc) == false) {
      x *= 2;
    }
    x *= (-1);
    pc.modHP(x);
    currentMP -= 5;
  }

  num monsterAttack () {
    return Random().nextInt(20) + super.stats[2];
  }

  num monsterDamage() {
    return Random().nextInt(super.baseWeaponDie) + stats[4];
  }

  void takeDamage (num damage) {
      super.modHP(-damage/(super.armorLevel));
  }

}

class Spell {
  
  String spellName = "", spellDescription = "";

  num spellCost = 0, spellPower = 0;

  String effect = "";

  Spell (String nam, String desc, num cost, num power, String eff) {
    spellName = nam;
    spellDescription = desc;
    spellCost = cost;
    spellPower = power;
    effect = eff;
  }

}