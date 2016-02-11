/**
 * @fileOverview This file has functions related to role settings view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: acl links collection.
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * RoleSettings View
 * @class RoleSettingsView
 * @constructor
 * @extends Backbone.View
 */
App.RoleSettingsView = Backbone.View.extend({
    template: JST['templates/role_settings'],
    tagName: 'section',
    className: 'clearfix row',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-update-role': 'saveRoleSettings'
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.roles = options.roles;
		this.acl_board_links = options.acl_board_links;
		this.board_user_roles = options.board_user_roles;
		this.acl_organization_links = options.acl_organization_links;
		this.organization_user_roles = options.organization_user_roles;
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            acl_links: this.model,
            roles: this.roles,
			acl_board_links: this.acl_board_links,
			board_user_roles: this.board_user_roles,
			acl_organization_links: this.acl_organization_links,
			organization_user_roles: this.organization_user_roles
        }));
        $('.js-admin-role-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-email-menu, .js-admin-setting-menu, .js-admin-board-menu').removeClass('active');
        this.showTooltip();
        return this;
    },
    /**
     * saveRoleSettings()
     * save role alloewd acl links
     * @param e
     * @type Object(DOM event)
     */
    saveRoleSettings: function(e) {
        var self = $(e.target);
        var data = {
            'acl_link_id': self.data('acl_link_id'),
            'role_id': self.data('role_id')
        };
        var role_setting = new App.RoleSetting();
        role_setting.set(data);
        role_setting.url = api_url + 'acl_links.json';
        role_setting.save(data);
    }
});
