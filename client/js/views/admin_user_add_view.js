/**
 * @fileOverview This file has functions related to admin user add view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Admin user add View
 * @class AdminUserAddView
 * @constructor
 * @extends Backbone.View
 */
App.AdminUserAddView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/admin_user_add'],
    tagName: 'article',
    className: 'clearfix',
    id: 'admin-user-add',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#AdminUserAddForm': 'adminUserAdd'
    },
    /**
     * adminUserAdd()
     * save user
     * @return false
     */
    adminUserAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var user = new App.User();
        user.url = api_url + 'users.json';
        user.save(data, {
            success: function(model, response) {
                if (response.error) {
                    if (response.error === 1) {
                        self.flash('danger', i18next.t('Email address already exist. Your registration process is not completed. Please, try again.'));
                    } else if (response.error === 2) {
                        self.flash('danger', i18next.t('Username already exists. Your registration process is not completed. Please, try again.'));
                    }
                    $('#inputPassword').val('');
                } else {
                    self.flash('success', i18next.t('User added successfully.'));
                    target[0].reset();
                    app.navigate('#/users', {
                        trigger: true,
                        replace: true
                    });
                }
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
