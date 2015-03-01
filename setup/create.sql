CREATE TABLE IF NOT EXISTS accidents (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
  "final_report" boolean DEFAULT 'f' NOT NULL,
  "date" varchar(255),
  "year" INTEGER,
  "county" varchar(255),
  "injury" TEXT,
  "fatal" boolean DEFAULT 'f' NOT NULL,
  "si_sp" varchar(2),
  "circumstances" TEXT,
  "shooter_age" INTEGER,
  "shooter_gender" varchar(1),
  "victim_age" INTEGER,
  "victim_gender" varchar(1),
  "weapon" varchar(255)
);
