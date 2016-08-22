class ConfigController < ApplicationController

  def blti_launch_url
    request.base_url + '/course-navigation'
  end

  def xml_config
     config_attrs = {
      'title' => 'Amaze LTI',
      'description' => 'The most impressive LTI app',
      'launch_url' => blti_launch_url,
      'icon' => view_context.image_url('amaze_icon.png'),
      'custom_params' => {
        'account_id' => '$Canvas.account.id',
        'user_id' => '$Canvas.user.id',
        'masquerading_user_id' => '$Canvas.masqueradingUser.userId',
        'domain' => '$Canvas.api.domain',
        'base_url' => '$Canvas.api.baseUrl',
        'membership_service_url' => '$ToolProxyBinding.memberships.url',
        'collaboration_members_url' => '$Canvas.api.collaborationMembers.url',
        'group_context_ids' => '$Canvas.group.contextIds',
        'assignment_title' => '$Canvas.assignment.title'
      },
      'extensions' => {
        'canvas.instructure.com' => {
          'course_navigation' => {
            'text' => 'Amaze',
            'url' => blti_launch_url
          },
        }
      }
    }
    tc = IMS::LTI::Services::ToolConfig.new(config_attrs)
    tc.set_ext_param('canvas.instructure.com', 'domain', request.host)
    render xml: tc.to_xml
  end
end
