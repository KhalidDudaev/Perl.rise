{ package rise::lib::fs;  use strict; use warnings;   
    { package rise::lib::fs::pathWorker; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::class','rise::lib::fs';   sub super { $rise::lib::fs::pathWorker::ISA[1] } my $self = 'rise::lib::fs::pathWorker'; sub self { $self }; BEGIN { __PACKAGE__->__RISE_COMMANDS } __PACKAGE__->interface_confirm; sub __OBJLIST__ {'public-function-cwd public-function-abs public-function-isAbs public-function-isRel public-function-basename public-function-ext'}
        { package rise::lib::fs::pathWorker::cwd; use rise::core::object::funcdecl; sub  cwd  {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]);
            my $cwdir; no warnings; sub cwdir ():lvalue; *cwdir = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'cwdir') unless (caller eq 'rise::lib::fs::pathWorker::cwd' || caller =~ m/^rise::lib::fs::pathWorker::cwd\b/o); $cwdir }; use warnings; 
            $cwdir = __RISE_MATCH $0 =~m/^(.*?)\w+(?:\.\w+)*$/gsx;
            return $cwdir->[0];
        }}

        { package rise::lib::fs::pathWorker::abs; use rise::core::object::funcdecl; sub  abs {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
             $fname = $self->cwd . $fname if $self->isRel($fname);
             return $fname;
        }}

        { package rise::lib::fs::pathWorker::isAbs; use rise::core::object::funcdecl; sub  isAbs {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return __RISE_MATCH $fname =~m/^(?:\w+\:|[\W]+)/;
        }}

        { package rise::lib::fs::pathWorker::isRel; use rise::core::object::funcdecl; sub  isRel {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return __RISE_MATCH $fname !~m/^(?:\w+\:|[\W]+)/;
        }}

        { package rise::lib::fs::pathWorker::basename; use rise::core::object::funcdecl; sub  basename {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            $fname      =~ s/^.*?(\w+(?:\.\w+)*)$/$1/sx;
            $fname      =~ s/^(.*?)(?:\.(\w+))?$/$1/sx;
            return $fname;
        }}

        { package rise::lib::fs::pathWorker::ext; use rise::core::object::funcdecl; sub  ext {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            $fname      =~ s/^.*?(\w+(?:\.\w+)*)$/$1/sx;
            $fname      =~ s/^(.*?)(?:\.(\w+))?$/$2/sx;
            return $fname;
        }}
    }
}

1;