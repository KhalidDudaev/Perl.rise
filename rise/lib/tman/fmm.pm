# File Modification Monitor
use rise::lib::fs;

{ package rise::lib::tman; use rise::core::object::namespace;   

    { package rise::lib::tman::fmm; use rise::core::object::class;  

        my $fs; no warnings; sub fs ():lvalue; *fs = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fs') unless (caller eq 'rise::lib::tman::fmm' || caller =~ m/^rise::lib::tman::fmm\b/o); $fs }; use warnings;  $fs = new rise::lib::fs;
        # public var diff     = 2;

        { package rise::lib::tman::fmm::monitor; use rise::core::object::function; sub monitor {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $spath; no warnings; local *spath; sub spath ():lvalue; *spath = sub ():lvalue {  $spath }; use warnings; my $diff; no warnings; local *diff; sub diff ():lvalue; *diff = sub ():lvalue {  $diff }; use warnings;  ($self,$spath,$diff) = ($_[0],$_[1],$_[2]||2); 
            my $tdiff; no warnings; sub tdiff ():lvalue; *tdiff = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tdiff') unless (caller eq 'rise::lib::tman::fmm::monitor' || caller =~ m/^rise::lib::tman::fmm::monitor\b/o); $tdiff }; use warnings; 
            my $sname; no warnings; sub sname ():lvalue; *sname = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'sname') unless (caller eq 'rise::lib::tman::fmm::monitor' || caller =~ m/^rise::lib::tman::fmm::monitor\b/o); $sname }; use warnings; 
            my $mname; no warnings; sub mname ():lvalue; *mname = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'mname') unless (caller eq 'rise::lib::tman::fmm::monitor' || caller =~ m/^rise::lib::tman::fmm::monitor\b/o); $mname }; use warnings; 

            foreach (@ {($self->fs->dir->listf($spath) )}){ $sname = $_;
                $tdiff = time - $self->fs->info->mtime($sname);
                next if $tdiff > $diff;
                $mname = $sname;
                last if $tdiff < $diff;
            }

            return $mname;
        }}
    }
}

1;