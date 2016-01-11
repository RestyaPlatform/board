/**
 * @fileOverview This file has functions related to plugin settings view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App == 'undefined') {
    App = {};
}
App.PluginSettingsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.folder = options.folder;
        this.render(options.plugin_settings);
    },
    template: JST['templates/plugin_setting'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#js-plugin-setting-form': 'updatePlugin',
    },
    /**
     * updatePlugin()
     * @return false
     */
    updatePlugin: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var plugin = new App.Plugin();
        plugin.url = api_url + 'plugins/settings.json';
        plugin.save(data, {
            success: function(model, response) {
                if (!_.isEmpty(response.success)) {
                    self.flash('success', i18next.t('Plugin updated successfully'));
                } else {
                    self.flash('danger', i18next.t('Plugin not updated successfully.'));
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
    render: function(plugin_settings) {
        this.$el.html(this.template({
            plugin_settings: plugin_settings,
            folder: this.folder
        }));
        $('.js-admin-plugin-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-role-menu, .js-admin-setting-menu, .js-admin-board-menu, .js-admin-email-menu').removeClass('active');
        return this;
    }
});
