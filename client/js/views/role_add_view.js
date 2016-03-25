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
 * Role add view
 * @class RoleAddView
 * @constructor
 * @extends Backbone.View
 */
App.RoleAddView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.render();
    },
    template: JST['templates/role_add'],
    tagName: 'article',
    className: 'clearfix',
    id: 'role-add',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#RoleAddForm': 'roleAdd'
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
                target[0].reset();
                app.navigate('#/roles', {
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
        $('.js-admin-user-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-setting-menu, .js-admin-email-menu, .js-admin-role-menu, .js-admin-board-menu').removeClass('active');
        this.showTooltip();
        return this;
    }
});
