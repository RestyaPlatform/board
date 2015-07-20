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
            roles: this.roles
        }));
        $('.js-admin-role-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-email-menu, .js-admin-setting-menu').removeClass('active');
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
