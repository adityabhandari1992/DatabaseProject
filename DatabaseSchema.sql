// I love Hemali

create DATABASE iPortal;
use iPortal;

create TABLE IF NOT EXISTS studentInfo (
    roll varchar(10) PRIMARY KEY,
    studentPassword varchar(40) NOT NULL,
    cpi numeric(4,2) NOT NULL CHECK (cpi>0 and cpi<10.01)
);

create TABLE IF NOT EXISTS companyInfo (
   companyID varchar(30) PRIMARY KEY,
   companyPassword varchar(40) NOT NULL
);

create TABLE IF NOT EXISTS admin (
    roll varchar(10) PRIMARY KEY,
    
    FOREIGN KEY (roll) references studentInfo(roll)
);

create TABLE IF NOT EXISTS department (
    dept varchar(50) PRIMARY KEY,
    deptCode tinyint NOT NULL CHECK (deptCode>0)
);

create TABLE IF NOT EXISTS venue (
    venueName varchar (50) PRIMARY KEY,
    capacity smallint DEFAULT 0 CHECK (capacity>=0)
);

create TABLE IF NOT EXISTS student (
    roll varchar(10) PRIMARY KEY,
    studentName varchar(60) NOT NULL,
    dept varchar(50) NOT NULL,
    program varchar(20) NOT NULL CHECK (program in ("B.Tech.", "Dual Degree")),
    year tinyint  NOT NULL CHECK (year in (2,3)),
    studentEmail varchar (60),
    studentPhone varchar (15),
    dob date,
    gender varchar(8) CHECK (gender in ("Male", "Female")),
    hostel tinyint CHECK (hostel>0),
    roomNo smallint CHECK (roomNo>0),
    cpi numeric(4,2),
    internStatus bit(1) NOT NULL,

    FOREIGN KEY (dept) references department(dept),
    FOREIGN KEY (roll) references studentInfo(roll)
);

create TABLE IF NOT EXISTS company (
    companyID varchar(30) PRIMARY KEY,
    companyName varchar(30) NOT NULL,
    city varchar(20),
    country varchar(20),
    contactPerson varchar(30),
    companyEmail varchar (60),
    companyPhone varchar (15),

    FOREIGN KEY (companyID) references companyInfo(companyID)
);

create TABLE IF NOT EXISTS profile (
    companyID varchar(30) NOT NULL,
    profileID int NOT NULL AUTO_INCREMENT,
    profileName varchar(40) NOT NULL,
    description text,
    place varchar(100),
    accommodation varchar(5) NOT NULL CHECK (accommodation in ("Yes","No")),
    deadline datetime NOT NULL,
    additionalInfo text,
    
    PRIMARY KEY (companyID,profileID),
    FOREIGN KEY (companyID) references company(companyID)
) ENGINE=MyISAM;

create TABLE IF NOT EXISTS profileDetails (
    companyID varchar(30) NOT NULL,
    profileID int NOT NULL,
    dept varchar(50) NOT NULL,
    secondYear bit(1) NOT NULL,
    thirdYear bit(1) NOT NULL,
    secondStipend int NOT NULL,
    thirdStipend int NOT NULL,
    unit varchar(20) NOT NULL,
    secondCPI numeric(4,2) NOT NULL,
    thirdCPI numeric(4,2) NOT NULL,

    PRIMARY KEY (companyID,profileID,dept),
    FOREIGN KEY (companyID,profileID) references profile(companyID,profileID),
    FOREIGN KEY (dept) references department(dept)
) ENGINE=MyISAM;

create TABLE IF NOT EXISTS profileSelection (
    companyID varchar(30) NOT NULL,
    profileID int NOT NULL,
    type varchar(50) NOT NULL CHECK (type in ("Aptitude Test", "Technical Test", "Group Discussion", "Interview")),

    PRIMARY KEY (companyID,profileID,type),
    FOREIGN KEY (companyID,profileID) references profile(companyID,profileID)
) ENGINE=MyISAM;

create TABLE IF NOT EXISTS signed (
    roll varchar(10),
    companyID varchar(30) NOT NULL,
    profileID int NOT NULL,
    job tinyint NOT NULL DEFAULT 2,

    PRIMARY KEY (roll,companyID,profileID),
    FOREIGN KEY (roll) references student(roll),
    FOREIGN KEY (companyID,profileID) references profile(companyID,profileID)
) ENGINE=MyISAM;

create TABLE IF NOT EXISTS shortlist (
    roll varchar(10) NOT NULL,
    companyID varchar(30) NOT NULL,
    profileID int NOT NULL,
    type varchar(50) NOT NULL,
    shortlisted tinyint NOT NULL DEFAULT 2,

    PRIMARY KEY (roll,companyID,profileID,type),
    FOREIGN KEY (roll) references student(roll),
    FOREIGN KEY (companyID,profileID,type) references profileSelection(companyID,profileID,type)
) ENGINE=MyISAM;

create TABLE IF NOT EXISTS test (
    roll varchar(10) NOT NULL,
    companyID varchar(30) NOT NULL,
    profileID int NOT NULL,
    type varchar(50) NOT NULL,
    testTime datetime,
    venueName varchar(50) NOT NULL,

    PRIMARY KEY (roll,companyID,profileID,type),
    FOREIGN KEY (roll) references student(roll),
    FOREIGN KEY (companyID,profileID,type) references profileSelection(companyID,profileID,type),
    FOREIGN KEY (venueName) references venue(venueName)
) ENGINE=MyISAM;
