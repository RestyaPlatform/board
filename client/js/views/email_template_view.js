/**
 * @fileOverview This file has functions related to email template view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
App.EmailTemplateView = Backbone.View.extend({
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
    template: JST['templates/email_templates'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#js-email-templates-form': 'updateTemplate',
    },
    /**
     * updateTemplate()
     * @return false
     */
    updateTemplate: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var email_template = new App.EmailTemplate();
        email_template.set('id', this.id);
        email_template.url = api_url + 'email_templates/' + this.id + '.json';
        email_template.save(data, {
            success: function(model, response) {
                if (!_.isEmpty(response) && (response === 'Success')) {
                    self.flash('success', i18next.t('Email Template has been updated successfully.'));
                } else {
                    self.flash('danger', i18next.t('Email Template not updated properly.'));
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
            this.id = 1;
        }
        email_templates = new App.EmailTemplateCollection();
        email_templates.url = api_url + 'email_templates/' + this.id + '.json';
        email_templates.fetch({
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
        //Changing the Title dynamically
        var self = this;
        if (!_.isEmpty(collections) && !_.isUndefined(self.id)) {
            var email_template = collections.filter(function(model) {
                if (parseInt(model.get('id')) === parseInt(self.id)) {
                    return model;
                }
            });
            if (email_template.length > 0) {
                changeTitle(i18next.t('Email Templates') + ' - ' + email_template[0].get('display_name'));
            }
        }
        $('.js-admin-email-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-role-menu, .js-admin-setting-menu, .js-admin-board-menu').removeClass('active');
        return this;
    }
});
