import {ALL_FEATURES} from '../src/models/Feature';

describe('Feature model', () => {
  it('has at least 6 features', () => {
    expect(ALL_FEATURES.length).toBeGreaterThanOrEqual(6);
  });

  it('every feature has required fields', () => {
    for (const f of ALL_FEATURES) {
      expect(f.id).toBeTruthy();
      expect(f.title).toBeTruthy();
      expect(f.shortDescription).toBeTruthy();
      expect(f.fullDescription).toBeTruthy();
      expect(f.category).toBeTruthy();
      expect(Array.isArray(f.steps)).toBe(true);
      expect(f.steps.length).toBeGreaterThan(0);
    }
  });

  it('all feature ids are unique', () => {
    const ids = ALL_FEATURES.map(f => f.id);
    expect(new Set(ids).size).toBe(ids.length);
  });

  it('includes left-nav and large-targets', () => {
    const ids = ALL_FEATURES.map(f => f.id);
    expect(ids).toContain('left-nav');
    expect(ids).toContain('large-targets');
  });

  it('features belong to known categories', () => {
    const valid = new Set(['Navigation', 'Visual', 'Motor Accessibility']);
    for (const f of ALL_FEATURES) {
      expect(valid.has(f.category)).toBe(true);
    }
  });
});
