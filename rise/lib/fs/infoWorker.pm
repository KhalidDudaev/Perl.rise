{ package rise::lib::fs; use rise::core::object::namespace;   
    { package rise::lib::fs::infoWorker; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1015032330"; sub VERSION {"2016.1015032330"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-dev  public-function-ino  public-function-mode  public-function-nlink  public-function-uid  public-function-gid  public-function-rdev  public-function-size  public-function-atime  public-function-mtime  public-function-ctime  public-function-blksize  public-function-blocks}} 

        { package rise::lib::fs::infoWorker::dev; use rise::core::object::function;  sub dev {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[0];
        }}
        { package rise::lib::fs::infoWorker::ino; use rise::core::object::function;  sub ino {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[1];
        }}
        { package rise::lib::fs::infoWorker::mode; use rise::core::object::function;  sub mode {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[2];
        }}
        { package rise::lib::fs::infoWorker::nlink; use rise::core::object::function;  sub nlink {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[3];
        }}
        { package rise::lib::fs::infoWorker::uid; use rise::core::object::function;  sub uid {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[4];
        }}
        { package rise::lib::fs::infoWorker::gid; use rise::core::object::function;  sub gid {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[5];
        }}
        { package rise::lib::fs::infoWorker::rdev; use rise::core::object::function;  sub rdev {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[6];
        }}
        { package rise::lib::fs::infoWorker::size; use rise::core::object::function; no warnings qw/redefine prototype/;  sub size  {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[7];
        }}
        { package rise::lib::fs::infoWorker::atime; use rise::core::object::function;  sub atime {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[8];
        }}
        { package rise::lib::fs::infoWorker::mtime; use rise::core::object::function;  sub mtime {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[9];
        }}
        { package rise::lib::fs::infoWorker::ctime; use rise::core::object::function;  sub ctime {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[10];
        }}
        { package rise::lib::fs::infoWorker::blksize; use rise::core::object::function;  sub blksize {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[11];
        }}
        { package rise::lib::fs::infoWorker::blocks; use rise::core::object::function;  sub blocks {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[12];
        }}
    }

}

1;