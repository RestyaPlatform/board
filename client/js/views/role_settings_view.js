/**
 * @fileOverview This file has functions related to role settings view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: acl links collection.
 */
if (typeof App === 'undefined') {
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
        'click .js-update-role': 'saveRoleSettings',
        'click .js-role-name': 'roleAddForm',
        'click .js-edit': 'roleEditForm',
        'submit form#RoleAddForm': 'roleAdd',
        'submit form#BoardUserRoleAddForm': 'boardUserRoleAdd',
        'submit form#OrganizationUserRoleAddForm': 'organizationUserRoleAdd',
        'submit form#RoleEditForm': 'roleEdit',
        'submit form#BoardUserRoleEditForm': 'boardUserRoleEdit',
        'submit form#OrganizationUserRoleEditForm': 'organizationUserRoleEdit'
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
            'role_id': self.data('role_id'),
            'table': self.data('table')
        };
        var role_setting = new App.RoleSetting();
        role_setting.set(data);
        role_setting.url = api_url + 'acl_links.json';
        role_setting.save(data);
    },
    roleAddForm: function(e) {
        e.preventDefault();
        return false;
    },
    roleEditForm: function(e) {
        e.preventDefault();
        return false;
    },
    /**
     * roleAdd()
     * save role
     * @return false
     */
    roleAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var role = new App.Role();
        role.url = api_url + 'roles.json';
        role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Role added successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * organizationUserRoleAdd()
     * save organization user role
     * @return false
     */
    organizationUserRoleAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var organization_user_role = new App.OrganizationUserRoles();
        organization_user_role.url = api_url + 'organization_user_roles.json';
        organization_user_role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Organization user role added successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * boardUserRoleAdd()
     * save board user role
     * @return false
     */
    boardUserRoleAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var board_user_role = new App.BoardUserRoles();
        board_user_role.url = api_url + 'board_user_roles.json';
        board_user_role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Board user role added successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * roleEdit()
     * save user
     * @return false
     */
    roleEdit: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var role = new App.Role();
        role.set('id', data.id);
        role.url = api_url + 'roles/' + data.id + '.json';
        role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Role has been updated successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * boardUserRoleEdit()
     * Update board user role
     * @return false
     */
    boardUserRoleEdit: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var board_user_role = new App.BoardUserRoles();
        board_user_role.set('id', data.id);
        board_user_role.url = api_url + 'board_user_roles/' + data.id + '.json';
        board_user_role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Role has been updated successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * organizationUserRoleEdit()
     * Update organization user role
     * @return false
     */
    organizationUserRoleEdit: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var organization_user_role = new App.OrganizationUserRoles();
        organization_user_role.set('id', data.id);
        organization_user_role.url = api_url + 'organization_user_roles/' + data.id + '.json';
        organization_user_role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Role has been updated successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    }
});
