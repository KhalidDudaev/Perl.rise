
{ package rise::lib;  use strict; use warnings;

    use Term::ReadKey;

    { package rise::lib::fileMonitor; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::class','rise::lib';   BEGIN { no strict 'refs'; *{'rise::lib::fileMonitor::'.$_} = \&{'rise::lib::IMPORT::'.$_} for keys %rise::lib::IMPORT::; }; sub super { $rise::lib::fileMonitor::ISA[1] } my $self = 'rise::lib::fileMonitor'; sub self { $self }; BEGIN { __PACKAGE__->__RISE_COMMANDS } __PACKAGE__->interface_confirm; sub __CLASS_MEMBERS__ {'public-function-MakeTask public-function-tasks public-function-start private-function-Monitor private-function-RKey private-function-RMode private-var-monitor'}

        # use Data::Dump 'dump';

      # ReadMode 1;

      my $monitor; no warnings; sub monitor ():lvalue; *monitor = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'monitor') unless (caller eq 'rise::lib::fileMonitor' || caller =~ m/^rise::lib::fileMonitor\b/o); $monitor }; use warnings;  $monitor = {};

      { package rise::lib::fileMonitor::MakeTask; use rise::core::ops::extends 'rise::core::object::function', 'rise::lib::fileMonitor'; use rise::core::object::function::helper; BEGIN { __PACKAGE__->__RISE_COMMANDS } sub  MakeTask  {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $taskName; no warnings; local *taskName; sub taskName ():lvalue; *taskName = sub ():lvalue {  $taskName }; use warnings; my $fileList; no warnings; local *fileList; sub fileList ():lvalue; *fileList = sub ():lvalue {  $fileList }; use warnings; my $actionRef; no warnings; local *actionRef; sub actionRef ():lvalue; *actionRef = sub ():lvalue {  $actionRef }; use warnings;  ($self,$taskName,$fileList,$actionRef) = ($_[0],$_[1],$_[2],$_[3]);
        $self->monitor->{$taskName}{files} = [];
        __RISE_PUSH $self->monitor->{$taskName}{files}, $fileList;
        $self->monitor->{$taskName}{action} = $actionRef;
      }}

      { package rise::lib::fileMonitor::tasks; use rise::core::ops::extends 'rise::core::object::function', 'rise::lib::fileMonitor'; use rise::core::object::function::helper; BEGIN { __PACKAGE__->__RISE_COMMANDS } sub  tasks  {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]);
         return $self->monitor;
      }}

      { package rise::lib::fileMonitor::start; use rise::core::ops::extends 'rise::core::object::function', 'rise::lib::fileMonitor'; use rise::core::object::function::helper; BEGIN { __PACKAGE__->__RISE_COMMANDS } sub  start  {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]);
        say '';
        say line { title => 'MONITOR START' };
        $self->Monitor($self->monitor);
        say line { title => 'MONITOR END' };
        say '';
      }}

      { package rise::lib::fileMonitor::Monitor; use rise::core::ops::extends 'rise::core::object::function', 'rise::lib::fileMonitor'; use rise::core::object::function::helper; BEGIN { __PACKAGE__->__RISE_COMMANDS } sub Monitor  { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'Monitor') unless (caller eq 'rise::lib::fileMonitor' || caller =~ m/^rise::lib::fileMonitor\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $monitor; no warnings; local *monitor; sub monitor ():lvalue; *monitor = sub ():lvalue {  $monitor }; use warnings;  ($self,$monitor) = ($_[0],$_[1]);
        my $tdiff; no warnings; sub tdiff ():lvalue; *tdiff = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tdiff') unless (caller eq 'rise::lib::fileMonitor::Monitor' || caller =~ m/^rise::lib::fileMonitor::Monitor\b/o); $tdiff }; use warnings;  $tdiff = 2;
        my $tname; no warnings; sub tname ():lvalue; *tname = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'tname') unless (caller eq 'rise::lib::fileMonitor::Monitor' || caller =~ m/^rise::lib::fileMonitor::Monitor\b/o); $tname }; use warnings;
        my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fname') unless (caller eq 'rise::lib::fileMonitor::Monitor' || caller =~ m/^rise::lib::fileMonitor::Monitor\b/o); $fname }; use warnings;
        my $fname_short; no warnings; sub fname_short ():lvalue; *fname_short = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'fname_short') unless (caller eq 'rise::lib::fileMonitor::Monitor' || caller =~ m/^rise::lib::fileMonitor::Monitor\b/o); $fname_short }; use warnings;
        my $key; no warnings; sub key ():lvalue; *key = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'key') unless (caller eq 'rise::lib::fileMonitor::Monitor' || caller =~ m/^rise::lib::fileMonitor::Monitor\b/o); $key }; use warnings;  $key = '';

        local $\ = '';

        $self->RMode('normal');
        while($key ne '27'){
          $key = '';
          while($tdiff > 1) {
            $key = ord($self->RKey() || '');                                           # получение числового кода символа ASCII
            goto END if $key eq '27';
            sleep 1;
            foreach(__RISE_R2A  __RISE_KEYS $monitor ) { $tname = $_;
              foreach($monitor->{$tname}{files} ) { $fname = $_;
                say dump($fname);
                $tdiff = time - (stat($fname))[9];
                ($fname_short) = __RISE_A2R $fname =~ m{.*(?:\\|\/)(.*?)$}sx;
                last if $tdiff <= 1;
              }
              last if $tdiff <= 1;
            }
          }
          $tdiff = 2;
          print 'MODIFAYED: task "' . $tname . '" | file "' . $fname_short . '" - ';
          $monitor->{$tname}{action}($fname);
          say 'PASSED';
          sleep 1;
        }
        $self->RMode('restore');
        END:
        return 1;
      }}

      { package rise::lib::fileMonitor::RKey; use rise::core::ops::extends 'rise::core::object::function', 'rise::lib::fileMonitor'; use rise::core::object::function::helper; BEGIN { __PACKAGE__->__RISE_COMMANDS } sub RKey  { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'RKey') unless (caller eq 'rise::lib::fileMonitor' || caller =~ m/^rise::lib::fileMonitor\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings;  ($self) = ($_[0]);
        return Term::ReadKey::ReadKey(-1);
      }}

      { package rise::lib::fileMonitor::RMode; use rise::core::ops::extends 'rise::core::object::function', 'rise::lib::fileMonitor'; use rise::core::object::function::helper; BEGIN { __PACKAGE__->__RISE_COMMANDS } sub RMode  { __PACKAGE__->__RISE_ERR('CODE_PRIVATE', 'RMode') unless (caller eq 'rise::lib::fileMonitor' || caller =~ m/^rise::lib::fileMonitor\b/o); my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $mode; no warnings; local *mode; sub mode ():lvalue; *mode = sub ():lvalue {  $mode }; use warnings;  ($self,$mode) = ($_[0],$_[1]);
        return Term::ReadKey::ReadMode($mode);
      }}

    }
}

1;
