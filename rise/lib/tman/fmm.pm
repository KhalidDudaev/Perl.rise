# File Modification Monitor
use rise::lib::fs;

{ package rise::lib::tman; use rise::core::object::namespace;   

    { package rise::lib::tman::fmm; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1204003026"; sub VERSION {"2016.1204003026"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { __PACKAGE__ } sub __CLASS_MEMBERS__ {q{public-function-monitor  private-var-fs}} 

         sub fs ():lvalue; *__fs__ = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fs') unless (caller eq 'rise::lib::tman::fmm' || caller =~ m/^rise::lib::tman::fmm\b/o); my $self = shift; $self->{'fs'} }; *fs = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fs') unless (caller eq 'rise::lib::tman::fmm' || caller =~ m/^rise::lib::tman::fmm\b/o); $__RISE_SELF__->{'fs'} };   fs = new rise::lib::fs::;
        # public var diff     = 2;

        { package rise::lib::tman::fmm::monitor; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub monitor {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $spath; no warnings; sub spath ():lvalue; *spath = sub ():lvalue { $spath }; use warnings; my $diff; no warnings; sub diff ():lvalue; *diff = sub ():lvalue { $diff }; use warnings;  ($spath,$diff) = ($_[0],$_[1]||2); 
            my $tdiff; no warnings; sub tdiff ():lvalue; *tdiff = sub ():lvalue { $tdiff }; use warnings; 
            my $sname; no warnings; sub sname ():lvalue; *sname = sub ():lvalue { $sname }; use warnings; 
            my $mname; no warnings; sub mname ():lvalue; *mname = sub ():lvalue { $mname }; use warnings; 

            # say "monitor >>> " ~ spath;

            foreach ( @ {($self->fs->dir->listf($spath) )}){ $sname = $_;
                # say "monitor >>> " ~ sname;
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