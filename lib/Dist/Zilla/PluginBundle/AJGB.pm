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

    [@Basic]

    [AutoMetaResources]
    bugtracker.rt = 1
    repository.github = user:ajgb
    homepage = http://search.cpan.org/dist/%{dist}

    [MetaConfig]
    [ModuleBuild]
    [PodCoverageTests]
    [PodSyntaxTests]
    [PkgVersion]
    [AutoVersion]

    [CheckChangesHasContent]
    [CheckExtraTests]
    [CompileTests]
    [EOLTests]
    [NoTabsTests]
    [InstallGuide]
    [KwaliteeTests]
    [PortabilityTests]
    [PodWeaver]
    [ReadmeFromPod]

=pod

=begin Pod::Coverage

    configure

=end Pod::Coverage

=cut

sub configure {
    my $self = shift;

    my $payload = $self->payload;

    $self->add_bundle('Basic');

    $self->add_plugins(
        qw(
            MetaConfig
            ModuleBuild
            PodCoverageTests
            PodSyntaxTests
            PkgVersion
            MetaJSON

            CheckChangesHasContent
            CheckExtraTests
            CompileTests
            EOLTests
            NoTabsTests
            InstallGuide
            KwaliteeTests
            PortabilityTests
            PodWeaver
            ReadmeFromPod
        ),
        (
            defined $payload->{version} && $payload->{vesion} =~ /\./ ? () :
            [
                AutoVersion => {
                    major => $payload->{version} || 1
                }
            ]
        ),
        [
            AutoMetaResources => {
                'repository.github' => 'user:ajgb',
                'bugtracker.rt' => 1,
                'homepage' => 'http://search.cpan.org/dist/%{dist}',
            },
        ],
    );
}

1;
