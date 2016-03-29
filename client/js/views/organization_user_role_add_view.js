/**
 * @fileOverview This file has functions related to admin user add view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * Organization user role add view
 * @class OrganizationUserRoleAddView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationUserRoleAddView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.render();
    },
    template: JST['templates/organization_user_role_add'],
    tagName: 'article',
    className: 'clearfix',
    id: 'organization-user-role-add',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#OrganizationUserRoleAddForm': 'organizationUserRoleAdd'
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
                target[0].reset();
                app.navigate('#/users', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template());
        $('.js-admin-role-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-setting-menu, .js-admin-email-menu, .js-admin-user-menu, .js-admin-board-menu').removeClass('active');
        this.showTooltip();
        return this;
    }
});
