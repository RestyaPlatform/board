/**
 * @fileOverview This file has functions related to setting view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: page view id.
 */
if (typeof App == 'undefined') {
    App = {};
}
App.SettingView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.id = options.id;
        this.getListing();
    },
    template: JST['templates/setting_list'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#js-setting-list-form': 'updateSetting',
    },
    /**
     * updateSetting()
     * @return false
     */
    updateSetting: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        if (!_.isUndefined(data.LDAP_LOGIN_ENABLED) && $('.js-checkbox').is(":checked")) {
            data.LDAP_LOGIN_ENABLED = 'true';
        } else {
            if (parseInt(this.id) === 2) {
                data.LDAP_LOGIN_ENABLED = 'false';
            }
        }
        if (!_.isUndefined(data.STANDARD_LOGIN_ENABLED) && $('.js-checkbox').is(":checked")) {
            data.STANDARD_LOGIN_ENABLED = 'true';
        } else {
            if (parseInt(this.id) === 2) {
                data.STANDARD_LOGIN_ENABLED = 'false';
            }
        }
        var self = this;
        var settingModel = new App.SettingCategory();
        settingModel.url = api_url + 'settings.json';
        settingModel.save(data, {
            success: function(model, response) {
                if (!_.isEmpty(response.success)) {
                    self.flash('success', response.success);
                } else {
                    self.flash('danger', 'Settings not updated properly.');
                }
            }
        });
        return false;
    },
    /** 
     * getListing()
     * get settings
     * @return false
     */
    getListing: function() {
        self = this;
        if (_.isUndefined(this.id)) {
            this.id = 3;
        }
        settingsCol = new App.SettingCategoryCollection();
        settingsCol.url = api_url + 'settings/' + this.id + '.json';
        settingsCol.fetch({
            cache: false,
            abortPending: true,
            success: function(collections, response) {
                self.render(collections);
            }
        });
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(collections) {
        this.$el.html(this.template({
            list: collections,
            id: this.id
        }));
        $('.js-admin-setting-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-email-menu, .js-admin-role-menu').removeClass('active');
        return this;
    }
});
