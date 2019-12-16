/**
 * @fileOverview This file has functions related to app template view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
App.AppsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.render();
    },
    template: JST['templates/app'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-update-app': 'updateApp',
    },
    /**
     * updateApp()
     * @return false
     */
    updateApp: function(e) {
        var target = $(e.currentTarget);
        var data = {};
        if (target.data('current-status') === true) {
            data.enable = false;
        } else {
            data.enable = true;
        }
        data.folder = target.data('folder');
        var self = this;
        var _app = new App.App();
        _app.url = api_url + 'apps/settings.json';
        _app.save(data, {
            success: function(model, response) {
                if (!_.isUndefined(response.success) && !_.isEmpty(response.success)) {
                    localforage.removeItem('apps');
                    self.flash('success', i18next.t('App updated successfully'));
                    location.reload();
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
    render: function() {
        var get_names = [];
        var getss = this.model;
        _.each(this.model, function(data) {
            get_names.push(data.name);
        });
        get_names.sort();
        var getting_new_array = [];
        _.each(get_names, function(data) {
            _.each(getss, function(datas) {
                if (data === datas.name) {
                    getting_new_array.push(datas);
                }
            });
        });
        this.$el.html(this.template({
            apps: getting_new_array,
        }));
        $('.js-admin-app-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-role-menu, .js-admin-setting-menu, .js-admin-board-menu, .js-admin-email-menu').removeClass('active');
        return this;
    }
});
