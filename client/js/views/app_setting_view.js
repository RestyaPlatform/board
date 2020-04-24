/**
 * @fileOverview This file has functions related to app settings view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
App.AppSettingsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.folder = options.folder;
        this.render(options.app_settings);
    },
    template: JST['templates/app_setting'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#js-app-setting-form': 'updateApp',
    },
    /**
     * updateApp()
     * @return false
     */
    updateApp: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var _app = new App.App();
        _app.url = api_url + 'apps/settings.json';
        _app.save(data, {
            success: function(model, response) {
                if (!_.isUndefined(response.success) && !_.isEmpty(response.success)) {
                    self.flash('success', i18next.t('App updated successfully'));
                    _.each(data, function(val, field) {
                        if (field !== 'folder' && field in window) {
                            window[field] = val;
                        }
                    });
                } else if (!_.isUndefined(response.error) && !_.isEmpty(response.error) && response.error !== null && response.error.type === 'File permission') {
                    self.flash('danger', i18next.t(' Please set permission to write in  %s', {
                        postProcess: 'sprintf',
                        sprintf: [response.error.content]
                    }));
                } else {
                    self.flash('danger', i18next.t('App not updated successfully.'));
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
    render: function(app_settings) {
        this.$el.html(this.template({
            app_settings: app_settings,
            folder: this.folder
        }));
        $('.js-admin-app-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-role-menu, .js-admin-setting-menu, .js-admin-board-menu, .js-admin-email-menu').removeClass('active');
        return this;
    }
});
