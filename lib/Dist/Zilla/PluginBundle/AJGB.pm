use strict;
use warnings;

package Dist::Zilla::PluginBundle::AJGB;

# ABSTRACT: Dist::Zilla plugins for AJGB

use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

=head1 SYNOPSIS

    # dist.ini
    [@AJGB]

=head1 DESCRIPTION

This is the plugin bundle for AJGB. It's an equivalent to:


    [ExecDir]
    [ShareDir]

    [GatherDir]
    exclude_filename = README
    exclude_filename = dist.ini
    exclude_filename = weaver.ini
    [MetaYAML]
    [MetaJSON]
    [License]
    [Manifest]
    [Test::Compile]
    [PodCoverageTests]
    [PodSyntaxTests]
    [EOLTests]
    [NoTabsTests]
    [KwaliteeTests]
    [Test::Portability]
    [Test::Synopsis]

    [PruneCruft]
    [ManifestSkip]

    [ExtraTests]
    [Authority]
    authority = cpan:AJGB
    do_metadata = 1
    [PodWeaver]
    config_plugin = @AJGB

    [MetaConfig]
    [AutoMetaResources]
    bugtracker.rt = 1
    repository.github = user:ajgb
    homepage = http://search.cpan.org/dist/%{dist}

    [AutoPrereqs]
    [MakeMaker]
    [ModuleBuild]

    [InstallGuide]
    [ReadmeFromPod]

    [Git::NextVersion]
    first_version = 0.01

    [CopyFilesFromBuild]
    copy = README

    [Git::Check]
    allow_dirty = Changes
    allow_dirty = dist.ini
    allow_dirty = README
    [CheckChangesHasContent]
    [CheckExtraTests]
    [TestRelease]
    [ConfirmRelease]

    [UploadToCPAN]

    [NextRelease]
    time_zone = Europe/London
    filename = Changes
    format = %-6v %{yyyy-MM-dd HH:mm:ss}d
    [Git::Tag]
    filename = Changes
    tag_format = %v
    [Git::Commit]
    time_zone = Europe/London
    [Git::Push]

=pod

=begin Pod::Coverage

    configure

=end Pod::Coverage

=cut

sub configure {
    my $self = shift;

    my $payload = $self->payload;

    # Dirs
    $self->add_plugins(
        qw(
          ExecDir
          ShareDir
        )
    );

    # FileGatherer
    $self->add_plugins(
        [
            GatherDir =>
              { exclude_filename => [ 'README', 'dist.ini', 'weaver.ini', ], }
        ],
        qw(
          MetaYAML
          MetaJSON
          License
          Manifest
          Test::Compile
          PodCoverageTests
          PodSyntaxTests
          EOLTests
          NoTabsTests
          KwaliteeTests
          Test::Portability
          Test::Synopsis
        ),
    );

    # FilePruner
    $self->add_plugins(
        qw(
          PruneCruft
          ManifestSkip
        ),
    );

    # FileMunger
    $self->add_plugins(
        qw(
          ExtraTests
        ),
        [
            Authority => {
                authority   => 'cpan:AJGB',
                do_metadata => 1,
            }
        ],
        [ PodWeaver          => { config_plugin => '@AJGB', } ],
    );

    # MetaProvider
    $self->add_plugins(
        qw(
          MetaConfig
        ),
        [
            AutoMetaResources => {
                'repository.github' => 'user:ajgb',
                'bugtracker.rt'     => 1,
                'homepage' => 'http://search.cpan.org/dist/%{dist}',
            },
        ],
    );

    # PrereqSource
    $self->add_plugins(
        qw(
          AutoPrereqs
          MakeMaker
          ModuleBuild
        ),
    );

    # PrereqSource / InstallTool
    $self->add_plugins(
        qw(
          ReadmeFromPod
          InstallGuide
        ),
    );

    # VersionProvider
    $self->add_plugins(
        [ 'Git::NextVersion' => { first_version => '0.01', } ],
    );

    # AfterBuild
    $self->add_plugins(
        [ CopyFilesFromBuild => { copy          => 'README', } ],
    );

    # BeforeRelease
    $self->add_plugins(
        [
            'Git::Check' =>
              { allow_dirty => [ 'README', 'dist.ini', 'weaver.ini', ], }
        ],
        qw(
          CheckChangesHasContent
          CheckExtraTests
          TestRelease
          ConfirmRelease
        ),
    );

    # Releaser
    $self->add_plugins(
        qw(
          UploadToCPAN
        )
    );

    # AfterRelease
    $self->add_plugins(
        [
            NextRelease => {
                time_zone => 'Europe/London',
                filename  => 'Changes',
                format    => '%-6v %{yyyy-MM-dd HH:mm:ss}d',
            }
        ],
        [
            'Git::Tag' => {
                filename   => 'Changes',
                tag_format => '%v',
            }
        ],
        [ 'Git::Commit'      => { time_zone     => 'Europe/London', } ],
        qw(
          Git::Push
        ),
    );
}

1;
