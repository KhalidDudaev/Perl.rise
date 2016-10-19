{ package rise::lib::fs; use rise::core::object::namespace;   
    { package rise::lib::fs::path; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1018013856"; sub VERSION {"2016.1018013856"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-cwd  public-function-toAbs  public-function-toRel  public-function-isAbs  public-function-isRel  public-function-path  public-function-filename  public-function-basename  public-function-ext}} 

        # public var slash          = '/';

        { package rise::lib::fs::path::cwd; use rise::core::object::function;  sub cwd {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  ($self) = ($_[0]); 
             my $cwdir; no warnings; sub cwdir ():lvalue; *cwdir = sub ():lvalue { $cwdir }; use warnings;  ($cwdir) = toList __RISE_MATCH $0 =~ m{^(.*?)[^\\\/]*$}sx;
            return $cwdir;
        }}

        { package rise::lib::fs::path::toAbs; use rise::core::object::function;  sub toAbs {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            $fname = $self->cwd . $fname if $self->isRel($fname);
            return $fname;
        }}

        { package rise::lib::fs::path::toRel; use rise::core::object::function;  sub toRel {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            my $cwdir; no warnings; sub cwdir ():lvalue; *cwdir = sub ():lvalue { $cwdir }; use warnings;  $cwdir = $self->cwd;
            $cwdir =~ s{\\}{\\\\}gsx;
            $fname =~ s{$cwdir}{}sx;
            # fname =~ replace:sx cwdir => "";
            return $fname;
        }}

        { package rise::lib::fs::path::isAbs; use rise::core::object::function;  sub isAbs {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            return __RISE_MATCH $fname =~ m{^(?:\w+\:|[\W]+)};
        }}

        { package rise::lib::fs::path::isRel; use rise::core::object::function;  sub isRel {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            return __RISE_MATCH $fname !~ m{^(?:\w+\:|[\W]+)};
        }}

        { package rise::lib::fs::path::path; use rise::core::object::function;  sub path {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
             my $p; no warnings; sub p ():lvalue; *p = sub ():lvalue { $p }; use warnings;  ($p) = __RISE_MATCH $fname =~ m{^(.*?)[^\\\/]*$}sx;
            return $p;
        }}

        { package rise::lib::fs::path::filename; use rise::core::object::function;  sub filename {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            $fname      =~ s{^.*?([^\\\/]*)$}{$1}sx;
            return $fname;
        }}

        { package rise::lib::fs::path::basename; use rise::core::object::function;  sub basename {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            $fname      =~ s{^.*?(\w+(?:\.\w+)*)$}{$1}sx;
            $fname      =~ s{^(.*?)(?:\.(\w+))?$}{$1}sx;
            return $fname;
        }}

        { package rise::lib::fs::path::ext; use rise::core::object::function;  sub ext {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            $fname      =~ s{^.*?(\w+(?:\.\w+)*)$}{$1}sx;
            $fname      =~ s{^(.*?)(?:\.(\w+))?$}{$2||''}sxe;
            return $fname;
        }}

        # public function isFile (name) { -e name && !-d _ }
        # public function isDir  (name) { -d name }
    }
}

1;