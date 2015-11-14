{ package rise::lib::fs;  use strict; use warnings;
    { package rise::lib::fs::path; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::class','rise::lib::fs';   BEGIN { no strict 'refs'; *{'rise::lib::fs::path::'.$_} = \&{'rise::lib::fs::IMPORT::'.$_} for keys %rise::lib::fs::IMPORT::; }; sub super { $rise::lib::fs::path::ISA[1] } my $self = 'rise::lib::fs::path'; sub self { $self }; BEGIN { __PACKAGE__->__RISE_COMMANDS } __PACKAGE__->interface_confirm; sub __OBJLIST__ {'public-function-cwd public-function-isAbs public-function-isRel'}
        { package rise::lib::fs::path::cwd; use rise::core::object::funcdecl; sub  cwd  {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]);
            my $cwdir; no warnings; sub cwdir ():lvalue; *cwdir = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'cwdir') unless (caller eq 'rise::lib::fs::path::cwd' || caller =~ m/^rise::lib::fs::path::cwd\b/o); $cwdir }; use warnings;
            $cwdir =  __RISE_A2R $0 =~ m/^(.*?)\w+(?:\.\w+)*$/sx;
            return $cwdir->[0];
        }}

        { package rise::lib::fs::path::isAbs; use rise::core::object::funcdecl; sub  isAbs {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            return !!1 if __RISE_A2R $fname =~ m/^(?:\w+\:|[\W]+)/gsx;
            return !!0;
        }}

        { package rise::lib::fs::path::isRel; use rise::core::object::funcdecl; sub  isRel {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $fname; no warnings; local *fname; sub fname ():lvalue; *fname = sub ():lvalue {  $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]);
            return !!1 if __RISE_A2R $fname !~ m/^(?:\w+\:|[\W]+)/gsx;
            return !!0;
        }}
    }
}

1;
